#!/usr/bin/env bash

# Write/Edit gate. PreToolUse(Bash) cannot stop a Claude that writes a
# script file and executes it via `bash script.sh` — the command surface
# looks benign. This hook inspects Write/Edit payloads for destructive
# patterns in the content itself and denies them at authoring time.

set -euo pipefail

HOOK_LOG_DIR="${HOME}/.claude/hooks"
HOOK_LOG="${HOOK_LOG_DIR}/guard.log"
HOOK_ID="write-guard"
HOOK_PROFILE="${CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE:-standard}"
DISABLED_HOOKS=",${CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS:-},"

case "$HOOK_PROFILE" in
  minimal)
    exit 0
    ;;
  standard|strict) ;;
  *) HOOK_PROFILE="standard" ;;
esac

case "$DISABLED_HOOKS" in
  *",$HOOK_ID,"*) exit 0 ;;
esac

log() {
  mkdir -p "$HOOK_LOG_DIR" 2>/dev/null || true
  if [ -d "$HOOK_LOG_DIR" ] && [ -w "$HOOK_LOG_DIR" ]; then
    # Size-based rotation: once guard.log passes 5MB, rename to guard.log.1 and
    # start a fresh file. One backup is kept; older history is discarded.
    if [ -f "$HOOK_LOG" ]; then
      local _sz
      _sz=$(wc -c < "$HOOK_LOG" 2>/dev/null || printf 0)
      if [ "${_sz:-0}" -gt 5242880 ]; then
        mv -f "$HOOK_LOG" "$HOOK_LOG.1" 2>/dev/null || true
      fi
    fi
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$HOOK_LOG" || true
  fi
}

deny() {
  local reason="$1"
  log "DENY: $reason"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}' "$reason"
  exit 0
}

INPUT="$(cat)"
[ -n "$INPUT" ] || deny "Blocked by write-guard: missing hook input cannot be evaluated safely"
command -v jq >/dev/null 2>&1 || deny "Blocked by write-guard: jq is required to parse hook input safely"

TOOL_NAME="$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || true)"
if [ -z "$TOOL_NAME" ]; then
  deny "Blocked by write-guard: hook input JSON cannot be parsed safely"
fi
case "$TOOL_NAME" in
  Write|Edit|MultiEdit|NotebookEdit) ;;
  *) exit 0 ;;
esac

FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"

existing_json() {
  if [ "$TOOL_NAME" != "Write" ] && [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ] && [ -r "$FILE_PATH" ]; then
    head -c 262144 "$FILE_PATH" 2>/dev/null | jq -Rs . 2>/dev/null && return 0
  fi
  printf '""'
}

CONTENT="$(
  { printf '%s\n' "$INPUT"; existing_json; } | jq -rs '
    def apply_edit($edit):
      ($edit.old_string // "") as $old
      | ($edit.new_string // "") as $new
      | if $old == "" then . + "\n" + $new
        else (split($old)) as $parts
          | if ($parts | length) < 2 then . + "\n" + $new
            elif ($edit.replace_all // false) then ($parts | join($new))
            else $parts[0] + $new + ($parts[1:] | join($old))
            end
        end;
    .[0] as $hook
    | (.[1] // "") as $existing
    | ($hook.tool_input // {}) as $args
    | if $hook.tool_name == "Write" then ($args.content // "")
      else
        ([ (if $args.new_string != null then {old_string: $args.old_string, new_string: $args.new_string, replace_all: $args.replace_all} else empty end) ]
          + ($args.edits // [])) as $edits
        | reduce $edits[] as $edit ($existing; apply_edit($edit))
      end
  ' 2>/dev/null || true
)"

[ "${#CONTENT}" -ge 5 ] || exit 0

CONTENT_LC="$(printf '%s' "$CONTENT" | tr '[:upper:]' '[:lower:]')"
CONTENT_NORM="$(printf '%s' "$CONTENT_LC" \
  | sed -E 's,(^|[[:space:]])(sudo|env)([[:space:]]+-[^[:space:]]+)*[[:space:]]+,\1,g' \
  | sed -E 's,(^|[[:space:]])/[^[:space:]]*/([a-z][a-z0-9._-]*),\1\2,g')"

check() {
  local pattern="$1"
  local reason="$2"
  if printf '%s' "$CONTENT_NORM" | grep -Eq "$pattern"; then
    deny "$reason"
  fi
}

log "tool=$TOOL_NAME path=${FILE_PATH:0:120}"

# Shell-level destructive payloads inside a file Claude is about to write
check '(^|[[:space:]])rm[[:space:]]+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|-r[[:space:]]+-f|-f[[:space:]]+-r|--recursive[[:space:]]+--force|--force[[:space:]]+--recursive)' "Blocked by write-guard: destructive rm in written content"
check '(^|[[:space:]])dd[[:space:]]+.*(if|of)=/dev/' "Blocked by write-guard: dd against /dev in written content"
check '(^|[[:space:]])mkfs([[:space:]]|\.)' "Blocked by write-guard: filesystem format in written content"
check '(^|[[:space:]])(shred|wipe)([[:space:]]|$)' "Blocked by write-guard: shred/wipe in written content"
check '(curl|wget)[[:space:]][^|;&]*\|[[:space:]]*(bash|sh|zsh|ksh|dash)' "Blocked by write-guard: curl|wget piped to shell in written content"
check '(^|[[:space:]])git[[:space:]]+push[[:space:]]+.*(--force|-f|--force-with-lease)' "Blocked by write-guard: force-push in written content"
check '(^|[[:space:]])git[[:space:]]+reset[[:space:]]+--hard' "Blocked by write-guard: git reset --hard in written content"
check '(^|[[:space:]])rsync[[:space:]]+.*--delete' "Blocked by write-guard: rsync --delete in written content"

# Cloud destructive payloads smuggled into script files. PreToolUse(Bash) never
# sees these because Claude just runs `bash script.sh`. Catch them at authoring.
check '(^|[[:space:]])terraform[[:space:]]+(apply|destroy)([[:space:]]|$)' "Blocked by write-guard: terraform apply/destroy in written content"
check '(^|[[:space:]])kubectl[[:space:]]+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale)([[:space:]]|$)' "Blocked by write-guard: kubectl mutating command in written content"
check '(^|[[:space:]])aws[[:space:]]+s3[[:space:]]+(rb[[:space:]]+.*--force|rm[[:space:]]+.*--recursive)' "Blocked by write-guard: destructive aws s3 in written content"
check '(^|[[:space:]])aws[[:space:]]+(iam|rds|dynamodb|cloudformation|ec2|eks|ecr|secretsmanager|ssm|kms|s3api|lambda|logs|sns|sqs|route53|cloudfront|elbv2|elb|efs|sagemaker|glue|redshift)[[:space:]]+delete-' "Blocked by write-guard: aws delete-* in written content"
check '(^|[[:space:]])gcloud[[:space:]]+([a-z-]+[[:space:]]+)+(delete|remove-iam-policy-binding)([[:space:]]|$)' "Blocked by write-guard: gcloud delete/remove in written content"
check '(^|[[:space:]])gcloud[[:space:]]+storage[[:space:]]+rm[[:space:]]+.*--recursive' "Blocked by write-guard: gcloud storage rm --recursive in written content"

# Language-level destructive payloads (same intent, different vehicle)
check 'shutil\.rmtree\([[:space:]]*("|'\'')/[^)]' "Blocked by write-guard: shutil.rmtree on absolute path"
check 'os\.system\([^)]*\b(rm[[:space:]]+-[a-z]*r[a-z]*f|mkfs|dd[[:space:]]+[^)]*of=)' "Blocked by write-guard: destructive os.system payload"
check 'subprocess\.(run|call|popen|check_call|check_output)\([^)]*\b(rm[[:space:]]+-[a-z]*r[a-z]*f|mkfs|dd[[:space:]]+[^)]*of=)' "Blocked by write-guard: destructive subprocess payload"
# List-form: subprocess.run(['rm', '-rf', ...]) or (["rm","-rf",...])
check 'subprocess\.(run|call|popen|check_call|check_output)\([[:space:]]*\[[[:space:]]*["'\'']rm["'\''][[:space:]]*,[[:space:]]*["'\''](-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|-r["'\''][[:space:]]*,[[:space:]]*["'\'']-f|-f["'\''][[:space:]]*,[[:space:]]*["'\'']-r)' "Blocked by write-guard: destructive subprocess list payload"
check 'fs\.rm(sync)?\([^)]*recursive[[:space:]]*:[[:space:]]*true' "Blocked by write-guard: fs.rmSync recursive in written content"
check 'file::remove_dir_all|std::fs::remove_dir_all' "Blocked by write-guard: remove_dir_all in written content"

# Go runtime destructive calls (same intent as shutil.rmtree / fs.rmSync recursive)
check 'os\.removeall\(' "Blocked by write-guard: os.RemoveAll in written content"
check 'syscall\.unlink\(' "Blocked by write-guard: syscall.Unlink in written content"

# PowerShell destructive forms — ps1 content edited via the unix hook path still
# needs to be screened. Matches Remove-Item with -Recurse plus -Force, or the
# short-form rd/rmdir aliases used as recursion vehicles.
check 'remove-item[[:space:]].*(-recurse[[:space:]].*-force|-force[[:space:]].*-recurse)' "Blocked by write-guard: Remove-Item -Recurse -Force in written content"
check '(^|[[:space:]]|;)(rd|rmdir)[[:space:]]+/s[[:space:]]+/q' "Blocked by write-guard: cmd rmdir /s /q in written content"

# shutil.rmtree with a variable argument — prior rule only caught literal
# absolute-path strings. The vehicle is the same; vary the payload, match the
# call site.
check 'shutil\.rmtree\([[:space:]]*[a-z_][a-z0-9_.]*[[:space:]]*[,)]' "Blocked by write-guard: shutil.rmtree with variable argument"

# Raw SQL destructive statements inside files. Typo-proof: match at statement
# boundaries (start of line or after ;) to avoid flagging prose.
check '(^|[[:space:]]|;)drop[[:space:]]+(database|schema|table)[[:space:]]+' "Blocked by write-guard: destructive SQL DROP in written content"
check '(^|[[:space:]]|;)truncate[[:space:]]+(table[[:space:]]+)?[a-z_][a-z0-9_]*' "Blocked by write-guard: SQL TRUNCATE in written content"
check '(^|[[:space:]]|;)delete[[:space:]]+from[[:space:]]+[a-z_][a-z0-9_]*[[:space:]]*;' "Blocked by write-guard: SQL DELETE without WHERE in written content"

log "ALLOW: no rule matched"
exit 0
