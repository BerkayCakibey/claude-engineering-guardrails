$hookId = "pretooluse-guard"
$hookProfile = $env:CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE
if ([string]::IsNullOrWhiteSpace($hookProfile)) {
    $hookProfile = "standard"
}
$hookProfile = $hookProfile.ToLowerInvariant()
if ($hookProfile -ne "minimal" -and $hookProfile -ne "standard" -and $hookProfile -ne "strict") {
    $hookProfile = "standard"
}

$disabledSource = if ($env:CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS) {
    $env:CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS
} else {
    ""
}
$disabledHooks = ",$disabledSource,".ToLowerInvariant()
if ($disabledHooks.Contains(",$hookId,")) {
    exit 0
}

function Deny-Hook($reason) {
    $result = @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = $reason
        }
    } | ConvertTo-Json -Depth 10 -Compress

    Write-Output $result
    exit 0
}

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) {
    $inputJson = ($input | Out-String)
}

if ([string]::IsNullOrWhiteSpace($inputJson)) {
    Deny-Hook "Blocked by pretooluse-guard: missing hook input cannot be evaluated safely"
}

try {
    $data = $inputJson | ConvertFrom-Json
} catch {
    Deny-Hook "Blocked by pretooluse-guard: hook input JSON cannot be parsed safely"
}

$toolName = $data.tool_name
$command = ""

if ($data.tool_input -and $data.tool_input.command) {
    $command = [string]$data.tool_input.command
}

if ($toolName -ne "Bash" -and $toolName -ne "PowerShell") {
    exit 0
}

$commandLc = $command.ToLowerInvariant()
$commandLc = $commandLc.Replace([string][char]0, "")

# Normalize obfuscation forms so the rules below still match:
#   empty-string concat (r""m, r''m), backslash escape (\rm), abs path prefix (/usr/bin/kubectl).
$commandNorm = $commandLc
$commandNorm = $commandNorm -replace '""',''
$commandNorm = $commandNorm -replace "''",''
$commandNorm = [regex]::Replace($commandNorm, '\\([a-zA-Z])', '$1')
$commandNorm = $commandNorm -replace '\\ ',' '
$commandNorm = [regex]::Replace($commandNorm, '(^|\s)/[^\s]*/([a-z][a-z0-9._-]*)', '$1$2')

function Deny-IfMatchNorm($pattern, $reason) {
    if ($commandNorm -match $pattern) {
        Deny-Hook $reason
    }
}

function Deny-IfMatch($pattern, $reason) {
    if ($commandLc -match $pattern) {
        Deny-Hook $reason
    }
}

function Get-CommandTokens {
    if ([string]::IsNullOrWhiteSpace($commandNorm)) {
        return @()
    }
    return @([regex]::Split($commandNorm.Trim(), '\s+') | Where-Object { $_ -ne "" })
}

function Test-TokenIn($token, [string[]]$values) {
    return $values -contains $token
}

function Get-KubectlFirstCommand {
    $tokens = Get-CommandTokens
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        if (($tokens[$i] -replace '^.*/', '') -ne "kubectl") {
            continue
        }
        $j = $i + 1
        while ($j -lt $tokens.Count) {
            $token = $tokens[$j]
            if ($token -eq "--") {
                $j += 1
                break
            }
            if ($token -in @("-n", "--namespace", "--context", "--kubeconfig", "--server", "--user", "--cluster", "--as", "--as-group", "--request-timeout", "--cache-dir", "--certificate-authority", "--client-certificate", "--client-key", "--token")) {
                $j += 2
                continue
            }
            if ($token -match '^(-n|--namespace|--context|--kubeconfig|--server|--user|--cluster|--as|--as-group|--request-timeout|--cache-dir|--certificate-authority|--client-certificate|--client-key|--token)=') {
                $j += 1
                continue
            }
            if ($token.StartsWith("-")) {
                $j += 1
                continue
            }
            return $token
        }
        if ($j -lt $tokens.Count) {
            return $tokens[$j]
        }
    }
    return ""
}

function Get-KubectlRolloutCommand {
    $tokens = Get-CommandTokens
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        if (($tokens[$i] -replace '^.*/', '') -ne "kubectl") {
            continue
        }
        $j = $i + 1
        while ($j -lt $tokens.Count) {
            $token = $tokens[$j]
            if ($token -eq "--") {
                $j += 1
                break
            }
            if ($token -in @("-n", "--namespace", "--context", "--kubeconfig", "--server", "--user", "--cluster", "--as", "--as-group", "--request-timeout", "--cache-dir", "--certificate-authority", "--client-certificate", "--client-key", "--token")) {
                $j += 2
                continue
            }
            if ($token -match '^(-n|--namespace|--context|--kubeconfig|--server|--user|--cluster|--as|--as-group|--request-timeout|--cache-dir|--certificate-authority|--client-certificate|--client-key|--token)=') {
                $j += 1
                continue
            }
            if ($token.StartsWith("-")) {
                $j += 1
                continue
            }
            if ($token -eq "rollout") {
                if (($j + 1) -lt $tokens.Count) {
                    return $tokens[$j + 1]
                }
                return ""
            }
            break
        }
    }
    return ""
}

function Get-TerraformFirstCommand {
    $tokens = Get-CommandTokens
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        if (($tokens[$i] -replace '^.*/', '') -ne "terraform") {
            continue
        }
        $j = $i + 1
        while ($j -lt $tokens.Count) {
            $token = $tokens[$j]
            if ($token -eq "--") {
                $j += 1
                break
            }
            if ($token -eq "-chdir") {
                $j += 2
                continue
            }
            if ($token -match '^-chdir=' -or $token -in @("-help", "--help", "-version", "--version")) {
                $j += 1
                continue
            }
            if ($token.StartsWith("-")) {
                $j += 1
                continue
            }
            return $token
        }
        if ($j -lt $tokens.Count) {
            return $tokens[$j]
        }
    }
    return ""
}

function Get-GitCommandLines {
    $tokens = Get-CommandTokens
    $lines = @()
    for ($i = 0; $i -lt $tokens.Count; $i++) {
        if (($tokens[$i] -replace '^.*/', '') -ne "git") {
            continue
        }
        $j = $i + 1
        while ($j -lt $tokens.Count) {
            $token = $tokens[$j]
            if ($token -eq "--") {
                $j += 1
                break
            }
            if ($token -in @("-c", "--git-dir", "--work-tree", "--namespace", "--super-prefix", "--config-env")) {
                $j += 2
                continue
            }
            if ($token.StartsWith("-")) {
                $j += 1
                continue
            }
            break
        }
        if ($j -lt $tokens.Count) {
            $lines += ("git " + ($tokens[$j..($tokens.Count - 1)] -join " "))
        }
    }
    return ($lines -join "`n")
}

$gitCommandNorm = Get-GitCommandLines

function Deny-IfMatchGit($pattern, $reason) {
    if (-not [string]::IsNullOrWhiteSpace($gitCommandNorm) -and $gitCommandNorm -match $pattern) {
        Deny-Hook $reason
    }
}

# --- obfuscation and indirection ---
Deny-IfMatch '(^|\s|;|&&|\|\|)eval(\s|$)' "Blocked by pretooluse-guard: eval is not allowed"
Deny-IfMatchNorm '(^|\s|;|&&|\|\|)eval(\s|$)' "Blocked by pretooluse-guard: eval is not allowed"
Deny-IfMatch '(base64|xxd|openssl\s+base64|openssl\s+enc)\s.*-d.*\|\s*(bash|sh|zsh|ksh|dash|eval)' "Blocked by pretooluse-guard: decoded payload piped to shell is not allowed"
Deny-IfMatchNorm '(^|\s|;)[a-z_][a-z0-9_]*=(rm|kubectl|terraform|dd|mkfs|shred|wipe)(\s|;|$)' "Blocked by pretooluse-guard: aliasing a destructive command via variable is not allowed"

# --- terraform ---
Deny-IfMatch '(^|\s)terraform\s+apply(\s|$)' "Blocked by pretooluse-guard: terraform apply is not allowed"
Deny-IfMatch '(^|\s)terraform\s+destroy(\s|$)' "Blocked by pretooluse-guard: terraform destroy is not allowed"
Deny-IfMatchNorm '(^|\s)terraform\s+apply(\s|$)' "Blocked by pretooluse-guard: terraform apply is not allowed"
Deny-IfMatchNorm '(^|\s)terraform\s+destroy(\s|$)' "Blocked by pretooluse-guard: terraform destroy is not allowed"
$terraformCommand = Get-TerraformFirstCommand
if ($terraformCommand -eq "apply") {
    Deny-Hook "Blocked by pretooluse-guard: terraform apply is not allowed"
}
if ($terraformCommand -eq "destroy") {
    Deny-Hook "Blocked by pretooluse-guard: terraform destroy is not allowed"
}

# --- kubectl ---
Deny-IfMatch '(^|\s)kubectl\s+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale|attach)(\s|$)' "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
Deny-IfMatchNorm '(^|\s)kubectl\s+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale|attach)(\s|$)' "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
Deny-IfMatch '(^|\s)kubectl\s+rollout\s+(restart|undo|pause|resume)(\s|$)' "Blocked by pretooluse-guard: kubectl rollout mutation is not allowed"
$kubectlCommand = Get-KubectlFirstCommand
if (Test-TokenIn $kubectlCommand @("apply", "delete", "patch", "exec", "cp", "port-forward", "scale", "set", "drain", "cordon", "uncordon", "taint", "label", "annotate", "replace", "create", "edit", "debug", "run", "expose", "autoscale", "attach")) {
    Deny-Hook "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
}
$kubectlRolloutCommand = Get-KubectlRolloutCommand
if (Test-TokenIn $kubectlRolloutCommand @("restart", "undo", "pause", "resume")) {
    Deny-Hook "Blocked by pretooluse-guard: kubectl rollout mutation is not allowed"
}

# --- remote script execution ---
if (($commandLc -match '(^|\s)(curl|wget)(\s|$)') -and ($commandLc -match '(\||&&|;)\s*(bash|sh|zsh|ksh|fish|powershell|pwsh)(\s|$)')) {
    Deny-Hook "Blocked by pretooluse-guard: remote script execution is not allowed"
}
# Two-stage: curl/wget writes a file, then bash/source runs it in the same shell.
if (($commandLc -match '(curl|wget)[^|;&]*(-o|>)\s*[^\s]+') -and ($commandLc -match '(;|&&|\|\|)\s*(bash|sh|zsh|ksh|source|\.)\s+')) {
    Deny-Hook "Blocked by pretooluse-guard: two-stage remote script execution is not allowed"
}
Deny-IfMatch '(^|;|&&|\|\|)\s*(source|\.)\s+/(tmp|var|dev)/[^\s]+\.(sh|bash|zsh)' "Blocked by pretooluse-guard: sourcing a transient script is not allowed"

# --- .env secrets leak ---
Deny-IfMatch '(^|\s)cat\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
Deny-IfMatchNorm '(^|\s)cat\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
Deny-IfMatch '(^|\s)source\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: sourcing .env files is not allowed"
Deny-IfMatchNorm '(^|\s)source\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: sourcing .env files is not allowed"
Deny-IfMatch '(^|\s)(head|tail|less)\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
Deny-IfMatchNorm '(^|\s)(head|tail|less)\s+[^\s]*\.env(\s|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
Deny-IfMatch 'export\s+\$\(\s*<\s*[^)]*\.env' "Blocked by pretooluse-guard: exporting .env files is not allowed"

# --- shell injection ---
Deny-IfMatch '(^|\s)(bash|sh|zsh|ksh)\s+-[^\s]*c(\s|$)' "Blocked by pretooluse-guard: shell -c execution is not allowed"

# --- rm -rf ---
if (
    $commandLc -match '(^|\s)rm\s+.*( *--recursive *--force| *--force *--recursive)' -or
    $commandLc -match '(^|\s)rm\s+.*-[a-z]*r[a-z]*f' -or
    $commandLc -match '(^|\s)rm\s+.*-[a-z]*f[a-z]*r' -or
    $commandNorm -match '(^|\s)rm\s+.*( *--recursive *--force| *--force *--recursive)' -or
    $commandNorm -match '(^|\s)rm\s+.*-[a-z]*r[a-z]*f' -or
    $commandNorm -match '(^|\s)rm\s+.*-[a-z]*f[a-z]*r'
) {
    Deny-Hook "Blocked by pretooluse-guard: rm -rf is not allowed"
}
# Split flags: rm -r -f OR rm -f -r
Deny-IfMatchNorm '(^|\s)rm\s+(-[a-z]*r[a-z]*\s+(-[a-z]*\s+)*-[a-z]*f|-[a-z]*f[a-z]*\s+(-[a-z]*\s+)*-[a-z]*r|--recursive\s+(-[^\s]+\s+)*--force|--force\s+(-[^\s]+\s+)*--recursive)' "Blocked by pretooluse-guard: rm with recursive+force flags is not allowed"
Deny-IfMatch '(^|\s)rm\s+(-[^\s]*\s+)*/(\s|\*|$)' "Blocked by pretooluse-guard: rm against root path is not allowed"
Deny-IfMatchNorm '(^|\s)rm\s+(-[^\s]*\s+)*/(\s|\*|$)' "Blocked by pretooluse-guard: rm against root path is not allowed"

# --- filesystem and process destructive patterns ---
Deny-IfMatch '(^|\s)chmod\s+.*(777|666|o\+[^\s]*w|a\+[^\s]*w)(\s|$)' "Blocked by pretooluse-guard: world-writable chmod is not allowed"
Deny-IfMatch '(^|\s)chown\s+.*(-[^\s]*r|--recursive).*root' "Blocked by pretooluse-guard: recursive chown to root is not allowed"
Deny-IfMatch '(^|\s)mkfs(\s|$)' "Blocked by pretooluse-guard: filesystem formatting is not allowed"
Deny-IfMatch '(^|\s)dd\s+.*(if|of)=' "Blocked by pretooluse-guard: raw disk copy is not allowed"
Deny-IfMatchNorm '(^|\s)dd\s+.*(if|of)=' "Blocked by pretooluse-guard: raw disk copy is not allowed"
Deny-IfMatch '>\s*/dev/(sd|nvme|mapper|xvd|vd|mmcblk|loop|hd)' "Blocked by pretooluse-guard: writing to block devices is not allowed"
Deny-IfMatchNorm '>\s*/dev/(sd|nvme|mapper|xvd|vd|mmcblk|loop|hd)' "Blocked by pretooluse-guard: writing to block devices is not allowed"
Deny-IfMatch '>\s*/etc/' "Blocked by pretooluse-guard: overwriting system config is not allowed"
Deny-IfMatch '(^|\s)systemctl\s+(-[^\s]+\s+)*(stop|restart|disable|mask)(\s|$)' "Blocked by pretooluse-guard: system service mutation is not allowed"
Deny-IfMatch '(^|\s)kill\s+-9\s+-1(\s|$)' "Blocked by pretooluse-guard: killing all processes is not allowed"
Deny-IfMatch '(^|\s)pkill\s+-9(\s|$)' "Blocked by pretooluse-guard: force-killing processes is not allowed"
Deny-IfMatch ':\(\)\s*\{\s*:\s*\|\s*:\s*&\s*\}\s*;\s*:' "Blocked by pretooluse-guard: fork bomb pattern is not allowed"
Deny-IfMatch '(^|\s)xargs\s+.*\srm(\s|$)' "Blocked by pretooluse-guard: xargs rm is not allowed"
Deny-IfMatch '(^|\s)find\s+.*-exec\s+([^\s]*/)?rm(\s|$)' "Blocked by pretooluse-guard: find -exec rm is not allowed"
Deny-IfMatch '(^|\s)find\s+.*-delete(\s|$)' "Blocked by pretooluse-guard: find -delete is not allowed"
Deny-IfMatch '(^|\s)rsync\s+.*--delete([-_a-z]*)?(\s|=|$)' "Blocked by pretooluse-guard: rsync --delete is not allowed"
Deny-IfMatch '(^|\s)shred(\s|$)' "Blocked by pretooluse-guard: shred is not allowed"
Deny-IfMatch '(^|\s)wipe(\s|$)' "Blocked by pretooluse-guard: wipe is not allowed"

# --- git destructive ---
Deny-IfMatch '(^|\s)git\s+push\s+.*(--force|--force-with-lease|-f)(\s|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
Deny-IfMatchNorm '(^|\s)git\s+push\s+.*(--force|--force-with-lease|-f)(\s|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
Deny-IfMatchGit '(^|\s)git\s+push\s+.*(--force|--force-with-lease|-f)(\s|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
Deny-IfMatch '(^|\s)git\s+push(\s+[^\s]+)*\s+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
Deny-IfMatchNorm '(^|\s)git\s+push(\s+[^\s]+)*\s+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
Deny-IfMatchGit '(^|\s)git\s+push(\s+[^\s]+)*\s+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
Deny-IfMatch '(^|\s)git\s+push(\s+[^\s]+)*\s+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
Deny-IfMatchNorm '(^|\s)git\s+push(\s+[^\s]+)*\s+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
Deny-IfMatchGit '(^|\s)git\s+push(\s+[^\s]+)*\s+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
Deny-IfMatch '(^|\s)git\s+reset\s+--hard(\s|$)' "Blocked by pretooluse-guard: git reset --hard is not allowed"
Deny-IfMatchGit '(^|\s)git\s+reset\s+--hard(\s|$)' "Blocked by pretooluse-guard: git reset --hard is not allowed"
Deny-IfMatch '(^|\s)git\s+clean\s+-[^\s]*f' "Blocked by pretooluse-guard: git clean -f is not allowed"
Deny-IfMatchGit '(^|\s)git\s+clean\s+-[^\s]*f' "Blocked by pretooluse-guard: git clean -f is not allowed"
Deny-IfMatch '(^|\s)git\s+branch\s+-d(\s|$)' "Blocked by pretooluse-guard: git branch delete is not allowed"
Deny-IfMatchGit '(^|\s)git\s+branch\s+-d(\s|$)' "Blocked by pretooluse-guard: git branch delete is not allowed"

# --- aws destructive ---
Deny-IfMatch '(^|\s)aws\s+s3\s+rb\s+.*--force' "Blocked by pretooluse-guard: aws s3 rb --force is not allowed"
Deny-IfMatch '(^|\s)aws\s+s3\s+rm\s+.*--recursive' "Blocked by pretooluse-guard: aws s3 rm --recursive is not allowed"
Deny-IfMatch '(^|\s)aws\s+(iam|rds|dynamodb|cloudformation|ec2|eks|ecr|secretsmanager|ssm|kms|s3api|lambda|logs|sns|sqs|route53|cloudfront|elbv2|elb|efs|sagemaker|glue|redshift)\s+delete-' "Blocked by pretooluse-guard: aws delete-* is not allowed"
Deny-IfMatch '(^|\s)aws\s+s3api\s+(delete-object|delete-bucket|put-bucket-policy)' "Blocked by pretooluse-guard: aws s3api destructive is not allowed"
Deny-IfMatch '(^|\s)aws\s+lambda\s+(delete-function|delete-alias|remove-permission)' "Blocked by pretooluse-guard: aws lambda destructive is not allowed"
Deny-IfMatch '(^|\s)aws\s+rds\s+(delete-db-instance|delete-db-cluster|delete-db-snapshot)' "Blocked by pretooluse-guard: aws rds destructive is not allowed"

# --- gcloud destructive ---
Deny-IfMatch '(^|\s)gcloud\s+([a-z-]+\s+)+delete(\s|$)' "Blocked by pretooluse-guard: gcloud delete is not allowed"
Deny-IfMatch '(^|\s)gcloud\s+projects\s+delete' "Blocked by pretooluse-guard: gcloud projects delete is not allowed"
Deny-IfMatch '(^|\s)gcloud\s+iam\s+service-accounts\s+delete' "Blocked by pretooluse-guard: gcloud service-account delete is not allowed"
Deny-IfMatch '(^|\s)gcloud\s+([a-z-]+\s+)+remove-iam-policy-binding' "Blocked by pretooluse-guard: gcloud remove-iam-policy-binding is not allowed"
Deny-IfMatch '(^|\s)gcloud\s+storage\s+rm\s+.*--recursive' "Blocked by pretooluse-guard: gcloud storage rm --recursive is not allowed"

# --- docker privileged / host-mount escape ---
Deny-IfMatch '(^|\s)docker\s+run\s+.*--privileged(\s|$)' "Blocked by pretooluse-guard: docker run --privileged is not allowed"
Deny-IfMatch '(^|\s)docker\s+run\s+.*(-v|--volume)[=\s]+/(:|/)' "Blocked by pretooluse-guard: docker host-root volume mount is not allowed"
Deny-IfMatchNorm '(^|\s)docker\s+run\s+.*(-v|--volume)[=\s]+/(:|/)' "Blocked by pretooluse-guard: docker host-root volume mount is not allowed"

# --- inline interpreter execution (standard and strict; minimal skips) ---
if ($hookProfile -ne "minimal") {
    Deny-IfMatch '(^|\s)(python[23]?|perl|ruby|node)\s+-[ec]\s+' "Blocked by pretooluse-guard: inline script execution is not allowed"
    Deny-IfMatchNorm '(^|\s)(python[23]?|perl|ruby|node)\s+-[ec]\s+' "Blocked by pretooluse-guard: inline script execution is not allowed"
    Deny-IfMatch '(^|\s)(python[23]?|perl|ruby|node)\s+<<' "Blocked by pretooluse-guard: heredoc script execution is not allowed"
    Deny-IfMatchNorm '(^|\s)(python[23]?|perl|ruby|node)\s+<<' "Blocked by pretooluse-guard: heredoc script execution is not allowed"
}

exit 0
