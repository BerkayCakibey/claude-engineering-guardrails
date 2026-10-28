#!/usr/bin/env bash
# Error Capture Hook (Hardened)
# Fires on PostToolUse (Bash) to detect command failures.
# Zero output on success. Never outputs raw command context.
#
# Security: Does NOT output raw error context to prevent secret leakage.
# Only outputs pattern name and a generic reminder.

set -euo pipefail

HOOK_ID="error-capture"
HOOK_PROFILE="${CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE:-standard}"
DISABLED_HOOKS=",${CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS:-},"

case "$HOOK_PROFILE" in
    minimal)
        exit 0
        ;;
    standard|strict)
        ;;
    *)
        HOOK_PROFILE="standard"
        ;;
esac

case "$DISABLED_HOOKS" in
    *",$HOOK_ID,"*)
        exit 0
        ;;
esac

# Read hook input from stdin (Claude Code PostToolUse contract)
INPUT="$(cat)"

# Exit silently if no input
[ -z "$INPUT" ] && exit 0

# Try to extract tool output from JSON stdin. PostToolUse payload shape varies:
# .tool_result may be a string, or an object with .stdout/.output. Older clients
# put plain text at .tool_result directly. Use a type-safe jq expression so an
# unexpected shape does not crash the hook under `set -euo pipefail`.
if command -v jq >/dev/null 2>&1; then
    OUTPUT="$(
        printf '%s' "$INPUT" | jq -r '
            def as_text:
              if type == "string" then .
              elif type == "array" then map(as_text) | join("\n")
              elif type == "object" then
                [ .stdout?, .stderr?, .output?, .content?, .error?, .text?, .message? | select(. != null) ]
                | if length > 0 then map(as_text) | join("\n") else tostring end
              elif . == null then ""
              else tostring end;
            [ (.tool_response? | as_text), (.tool_result? | as_text), (.error? | as_text) ] | join("\n")
        ' 2>/dev/null || true
    )"
else
    # Without jq, skip processing
    exit 0
fi

# Exit silently if no output or empty
[ -z "$OUTPUT" ] && exit 0

# Error patterns — ordered by specificity
ERROR_PATTERNS=(
    "Traceback (most recent call last)"
    "panic:"
    "FATAL:"
    "fatal:"
    "Build failed"
    "Compilation failed"
    "Test failed"
    "command not found"
    "No such file or directory"
    "Permission denied"
    "ModuleNotFoundError"
    "ImportError"
    "SyntaxError"
    "TypeError"
    "Cannot find module"
    "ENOENT"
    "EACCES"
    "ECONNREFUSED"
    "npm ERR!"
    "pnpm ERR!"
    "segmentation fault"
    "core dumped"
)

# False positive exclusions
EXCLUSIONS=(
    "error-capture"
    "error_handler"
    "errorHandler"
    "error.log"
    "console.error"
    "catch (error"
    "catch (err"
    ".error("
    "no error"
    "without error"
    "error-free"
)

# Check exclusions first
for excl in "${EXCLUSIONS[@]}"; do
    if [[ "$OUTPUT" == *"$excl"* ]]; then
        exit 0
    fi
done

# Check for error patterns
contains_error=false
matched_pattern=""
for pattern in "${ERROR_PATTERNS[@]}"; do
    if [[ "$OUTPUT" == *"$pattern"* ]]; then
        contains_error=true
        matched_pattern="$pattern"
        break
    fi
done

# Exit silently if no error
[ "$contains_error" = false ] && exit 0

# Output a concise reminder — NO raw context (secret leakage prevention).
# Keep the message generic: skills that might help (si-remember, si-review,
# debugger) are install-profile-specific and may not be present.
cat << EOF
<error-detected>
Command error detected (pattern: "$matched_pattern").
Diagnose the failure before retrying; avoid rerunning the same command blindly.
</error-detected>
EOF
