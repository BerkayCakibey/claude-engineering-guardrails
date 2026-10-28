#!/usr/bin/env pwsh

# Error Capture Hook (Hardened)
# Fires on PostToolUse (Bash) to detect command failures.
# Zero output on success. Never outputs raw command context.
#
# Security: Does NOT output raw error context to prevent secret leakage.
# Only outputs pattern name and a generic reminder.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$hookId = "error-capture"
$hookProfile = $env:CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE
if ([string]::IsNullOrWhiteSpace($hookProfile)) {
    $hookProfile = "standard"
}
$hookProfile = $hookProfile.ToLowerInvariant()

if ($hookProfile -eq "minimal") {
    exit 0
}
if ($hookProfile -ne "standard" -and $hookProfile -ne "strict") {
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

function Get-ObjectPropertyValue {
    param(
        [Parameter(Mandatory = $false)]
        $Object,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $Object) {
        return $null
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function Get-TextValue {
    param(
        [Parameter(Mandatory = $false)]
        $Value
    )

    if ($null -eq $Value) {
        return ""
    }
    if ($Value -is [string]) {
        return $Value
    }
    if ($Value -is [System.Array]) {
        $parts = @()
        foreach ($item in $Value) {
            $parts += Get-TextValue -Value $item
        }
        return ($parts -join "`n")
    }
    if ($Value -is [System.Management.Automation.PSCustomObject]) {
        $parts = @()
        foreach ($name in @("stdout", "stderr", "output", "content", "error", "text", "message")) {
            $inner = Get-ObjectPropertyValue -Object $Value -Name $name
            if ($null -ne $inner) {
                $parts += Get-TextValue -Value $inner
            }
        }
        if ($parts.Count -gt 0) {
            return ($parts -join "`n")
        }
        return ($Value | ConvertTo-Json -Compress -Depth 5)
    }
    return [string]$Value
}

# Read hook input from stdin (Claude Code PostToolUse contract)
$INPUT = [Console]::In.ReadToEnd()

# Exit silently if no input
if ([string]::IsNullOrWhiteSpace($INPUT)) {
    exit 0
}

# Try to extract tool output from JSON stdin
try {
    $DATA = $INPUT | ConvertFrom-Json
    $parts = @()
    foreach ($name in @("tool_response", "tool_result", "error")) {
        $parts += Get-TextValue -Value (Get-ObjectPropertyValue -Object $DATA -Name $name)
    }
    $OUTPUT = ($parts -join "`n")
} catch {
    # Without JSON parsing, skip processing
    exit 0
}

# Exit silently if no output or empty
if ([string]::IsNullOrWhiteSpace($OUTPUT)) {
    exit 0
}

# Error patterns — ordered by specificity
$ERROR_PATTERNS = @(
    "Traceback (most recent call last)",
    "panic:",
    "FATAL:",
    "fatal:",
    "Build failed",
    "Compilation failed",
    "Test failed",
    "command not found",
    "No such file or directory",
    "Permission denied",
    "ModuleNotFoundError",
    "ImportError",
    "SyntaxError",
    "TypeError",
    "Cannot find module",
    "ENOENT",
    "EACCES",
    "ECONNREFUSED",
    "npm ERR!",
    "pnpm ERR!",
    "segmentation fault",
    "core dumped"
)

# False positive exclusions
$EXCLUSIONS = @(
    "error-capture",
    "error_handler",
    "errorHandler",
    "error.log",
    "console.error",
    "catch (error",
    "catch (err",
    ".error(",
    "no error",
    "without error",
    "error-free"
)

# Check exclusions first
foreach ($excl in $EXCLUSIONS) {
    if ($OUTPUT -like "*$excl*") {
        exit 0
    }
}

# Check for error patterns
$CONTAINS_ERROR = $false
$MATCHED_PATTERN = ""
foreach ($pattern in $ERROR_PATTERNS) {
    if ($OUTPUT -like "*$pattern*") {
        $CONTAINS_ERROR = $true
        $MATCHED_PATTERN = $pattern
        break
    }
}

# Exit silently if no error
if (-not $CONTAINS_ERROR) {
    exit 0
}

# Output a concise reminder — NO raw context (secret leakage prevention).
# Keep the message generic: skills that might help are install-profile-specific
# and may not be present.
Write-Output @"
<error-detected>
Command error detected (pattern: "$MATCHED_PATTERN").
Diagnose the failure before retrying; avoid rerunning the same command blindly.
</error-detected>
"@
