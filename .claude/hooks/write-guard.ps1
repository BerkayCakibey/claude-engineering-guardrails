# Write/Edit content guard (PowerShell parity of write-guard.sh).
#
# PreToolUse(Bash) cannot stop a Claude that writes a script file and then
# executes it via `bash script.sh` — the command surface looks benign. This
# hook inspects Write/Edit payloads for destructive patterns in the content
# itself and denies them at authoring time on Windows/PowerShell.

$ErrorActionPreference = "Stop"

$hookLogDir   = Join-Path $HOME ".claude\hooks"
$hookLog      = Join-Path $hookLogDir "guard.log"
$hookId       = "write-guard"
$hookProfile  = if ($env:CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE) {
    $env:CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE
} else {
    "standard"
}
$disabledRaw  = if ($env:CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS) {
    $env:CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS
} else {
    ""
}
$disabled     = ",$disabledRaw,"

switch ($hookProfile) {
    "minimal"            { exit 0 }
    { $_ -in "standard","strict" } { }
    default              { $hookProfile = "standard" }
}

if ($disabled -like "*,$hookId,*") { exit 0 }

function Write-Log($msg) {
    try {
        if (-not (Test-Path $hookLogDir)) {
            New-Item -ItemType Directory -Path $hookLogDir -Force | Out-Null
        }
        # Size-based rotation: once guard.log passes 5MB, rename to guard.log.1
        # and start fresh. One backup is kept; older history is discarded.
        if (Test-Path $hookLog) {
            $sz = (Get-Item $hookLog -ErrorAction SilentlyContinue).Length
            if ($sz -gt 5242880) {
                Move-Item -Path $hookLog -Destination "$hookLog.1" -Force -ErrorAction SilentlyContinue
            }
        }
        $stamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Add-Content -Path $hookLog -Value "[$stamp] $msg" -ErrorAction SilentlyContinue
    } catch { }
}

function Deny-Hook($reason) {
    Write-Log "DENY: $reason"
    $payload = @{
        hookSpecificOutput = @{
            hookEventName            = "PreToolUse"
            permissionDecision       = "deny"
            permissionDecisionReason = $reason
        }
    } | ConvertTo-Json -Compress -Depth 5
    Write-Output $payload
    exit 0
}

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) {
    $raw = ($input | Out-String)
}
if ([string]::IsNullOrWhiteSpace($raw)) { Deny-Hook "Blocked by write-guard: missing hook input cannot be evaluated safely" }

try { $input = $raw | ConvertFrom-Json } catch { Deny-Hook "Blocked by write-guard: hook input JSON cannot be parsed safely" }

$toolName = $input.tool_name
if ($toolName -notin @("Write","Edit","MultiEdit","NotebookEdit")) { exit 0 }

$filePath = $input.tool_input.file_path
if (-not $filePath) { $filePath = "" }

function Apply-Edit([string]$text, $edit) {
    $old = if ($edit.old_string) { [string]$edit.old_string } else { "" }
    $new = if ($edit.new_string) { [string]$edit.new_string } else { "" }
    if ($old -eq "") { return $text + "`n" + $new }
    $idx = $text.IndexOf($old, [System.StringComparison]::Ordinal)
    if ($idx -lt 0) { return $text + "`n" + $new }
    if ($edit.replace_all) { return $text.Replace($old, $new) }
    return $text.Substring(0, $idx) + $new + $text.Substring($idx + $old.Length)
}

$existing = ""
if ($toolName -ne "Write" -and $filePath -and (Test-Path -LiteralPath $filePath -PathType Leaf)) {
    try {
        $existing = [string](Get-Content -Raw -LiteralPath $filePath -ErrorAction SilentlyContinue)
        if ($existing.Length -gt 262144) { $existing = $existing.Substring(0,262144) }
    } catch { $existing = "" }
}

if ($toolName -eq "Write") {
    $content = if ($input.tool_input.content) { [string]$input.tool_input.content } else { "" }
} else {
    $edits = @()
    if ($null -ne $input.tool_input.new_string) { $edits += @($input.tool_input) }
    if ($input.tool_input.edits) {
        foreach ($e in $input.tool_input.edits) { $edits += @($e) }
    }
    $content = $existing
    foreach ($e in $edits) { $content = Apply-Edit $content $e }
}

if ($content.Length -lt 5) { exit 0 }
$lc = $content.ToLower()
$lc = [regex]::Replace($lc, '(^|\s)(sudo|env)(\s+-[^\s]+)*\s+', '$1')
$lc = [regex]::Replace($lc, '(^|\s)/[^\s]*/([a-z][a-z0-9._-]*)', '$1$2')

function Check-Pattern($pattern, $reason) {
    if ($lc -match $pattern) { Deny-Hook $reason }
}

Write-Log ("tool={0} path={1}" -f $toolName, $filePath.Substring(0,[Math]::Min(120,$filePath.Length)))

# Shell-level destructive payloads
Check-Pattern '(^|\s)rm\s+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|-r\s+-f|-f\s+-r|--recursive\s+--force|--force\s+--recursive)' "Blocked by write-guard: destructive rm in written content"
Check-Pattern '(^|\s)dd\s+.*(if|of)=/dev/' "Blocked by write-guard: dd against /dev in written content"
Check-Pattern '(^|\s)mkfs(\s|\.)' "Blocked by write-guard: filesystem format in written content"
Check-Pattern '(^|\s)(shred|wipe)(\s|$)' "Blocked by write-guard: shred/wipe in written content"
Check-Pattern '(curl|wget)\s[^|;&]*\|\s*(bash|sh|zsh|ksh|dash)' "Blocked by write-guard: curl|wget piped to shell in written content"
Check-Pattern '(^|\s)git\s+push\s+.*(--force|-f|--force-with-lease)' "Blocked by write-guard: force-push in written content"
Check-Pattern '(^|\s)git\s+reset\s+--hard' "Blocked by write-guard: git reset --hard in written content"
Check-Pattern '(^|\s)rsync\s+.*--delete' "Blocked by write-guard: rsync --delete in written content"

# Language-level destructive payloads
Check-Pattern 'shutil\.rmtree\(\s*("|'')/[^)]' "Blocked by write-guard: shutil.rmtree on absolute path"
Check-Pattern 'shutil\.rmtree\(\s*[a-z_][a-z0-9_.]*\s*[,)]' "Blocked by write-guard: shutil.rmtree with variable argument"
Check-Pattern 'os\.system\([^)]*\b(rm\s+-[a-z]*r[a-z]*f|mkfs|dd\s+[^)]*of=)' "Blocked by write-guard: destructive os.system payload"
Check-Pattern 'subprocess\.(run|call|popen|check_call|check_output)\([^)]*\b(rm\s+-[a-z]*r[a-z]*f|mkfs|dd\s+[^)]*of=)' "Blocked by write-guard: destructive subprocess payload"
Check-Pattern 'subprocess\.(run|call|popen|check_call|check_output)\(\s*\[\s*["'']rm["'']\s*,\s*["''](-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|-r["'']\s*,\s*["'']-f|-f["'']\s*,\s*["'']-r)' "Blocked by write-guard: destructive subprocess list payload"
Check-Pattern 'fs\.rm(sync)?\([^)]*recursive\s*:\s*true' "Blocked by write-guard: fs.rmSync recursive in written content"
Check-Pattern 'file::remove_dir_all|std::fs::remove_dir_all' "Blocked by write-guard: remove_dir_all in written content"
Check-Pattern 'os\.removeall\(' "Blocked by write-guard: os.RemoveAll in written content"
Check-Pattern 'syscall\.unlink\(' "Blocked by write-guard: syscall.Unlink in written content"

# PowerShell destructive forms
Check-Pattern 'remove-item\s+.*(-recurse\s+.*-force|-force\s+.*-recurse)' "Blocked by write-guard: Remove-Item -Recurse -Force in written content"
Check-Pattern '(^|\s|;)(rd|rmdir)\s+/s\s+/q' "Blocked by write-guard: cmd rmdir /s /q in written content"

# Cloud destructive payloads (terraform / kubectl / aws / gcloud) smuggled into scripts
Check-Pattern '(^|\s)terraform\s+(apply|destroy)(\s|$)' "Blocked by write-guard: terraform apply/destroy in written content"
Check-Pattern '(^|\s)kubectl\s+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale)(\s|$)' "Blocked by write-guard: kubectl mutating command in written content"
Check-Pattern '(^|\s)aws\s+s3\s+(rb\s+.*--force|rm\s+.*--recursive)' "Blocked by write-guard: destructive aws s3 in written content"
Check-Pattern '(^|\s)aws\s+(iam|rds|dynamodb|cloudformation|ec2|eks|ecr|secretsmanager|ssm|kms|s3api|lambda|logs|sns|sqs|route53|cloudfront|elbv2|elb|efs|sagemaker|glue|redshift)\s+delete-' "Blocked by write-guard: aws delete-* in written content"
Check-Pattern '(^|\s)gcloud\s+([a-z-]+\s+)+(delete|remove-iam-policy-binding)(\s|$)' "Blocked by write-guard: gcloud delete/remove in written content"
Check-Pattern '(^|\s)gcloud\s+storage\s+rm\s+.*--recursive' "Blocked by write-guard: gcloud storage rm --recursive in written content"

# Raw SQL destructive statements
Check-Pattern '(^|\s|;)drop\s+(database|schema|table)\s+' "Blocked by write-guard: destructive SQL DROP in written content"
Check-Pattern '(^|\s|;)truncate\s+(table\s+)?[a-z_][a-z0-9_]*' "Blocked by write-guard: SQL TRUNCATE in written content"
Check-Pattern '(^|\s|;)delete\s+from\s+[a-z_][a-z0-9_]*\s*;' "Blocked by write-guard: SQL DELETE without WHERE in written content"

Write-Log "ALLOW: no rule matched"
exit 0
