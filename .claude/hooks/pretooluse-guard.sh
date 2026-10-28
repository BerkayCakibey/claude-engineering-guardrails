#!/usr/bin/env bash

set -euo pipefail

HOOK_LOG_DIR="${HOME}/.claude/hooks"
HOOK_LOG="${HOOK_LOG_DIR}/guard.log"
HOOK_ID="pretooluse-guard"
HOOK_PROFILE="${CLAUDE_ENGINEERING_GUARDRAILS_HOOK_PROFILE:-standard}"
DISABLED_HOOKS=",${CLAUDE_ENGINEERING_GUARDRAILS_DISABLED_HOOKS:-},"

case "$HOOK_PROFILE" in
  minimal|standard|strict)
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

log() {
  mkdir -p "$HOOK_LOG_DIR" 2>/dev/null || true
  if [ -d "$HOOK_LOG_DIR" ] && [ -w "$HOOK_LOG_DIR" ]; then
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

deny_if_matches() {
  local pattern="$1"
  local reason="$2"

  if printf '%s\n' "$COMMAND_LC" | grep -Eq "$pattern"; then
    deny "$reason"
  fi
}

token_in_list() {
  local token="$1"
  shift

  local item
  for item in "$@"; do
    if [ "$token" = "$item" ]; then
      return 0
    fi
  done
  return 1
}

kubectl_first_command() {
  local -a tokens
  local i
  local j
  local token
  read -r -d '' -a tokens <<< "$COMMAND_NORM" || true

  for i in "${!tokens[@]}"; do
    [ "${tokens[$i]##*/}" = "kubectl" ] || continue
    j=$((i + 1))
    while [ "$j" -lt "${#tokens[@]}" ]; do
      token="${tokens[$j]}"
      case "$token" in
        --)
          j=$((j + 1))
          break
          ;;
        -n|--namespace|--context|--kubeconfig|--server|--user|--cluster|--as|--as-group|--request-timeout|--cache-dir|--certificate-authority|--client-certificate|--client-key|--token)
          j=$((j + 2))
          ;;
        -n=*|--namespace=*|--context=*|--kubeconfig=*|--server=*|--user=*|--cluster=*|--as=*|--as-group=*|--request-timeout=*|--cache-dir=*|--certificate-authority=*|--client-certificate=*|--client-key=*|--token=*)
          j=$((j + 1))
          ;;
        -*)
          j=$((j + 1))
          ;;
        *)
          printf '%s' "$token"
          return 0
          ;;
      esac
    done
    if [ "$j" -lt "${#tokens[@]}" ]; then
      printf '%s' "${tokens[$j]}"
      return 0
    fi
  done

  return 1
}

kubectl_rollout_command() {
  local -a tokens
  local i
  local j
  local token
  read -r -d '' -a tokens <<< "$COMMAND_NORM" || true

  for i in "${!tokens[@]}"; do
    [ "${tokens[$i]##*/}" = "kubectl" ] || continue
    j=$((i + 1))
    while [ "$j" -lt "${#tokens[@]}" ]; do
      token="${tokens[$j]}"
      case "$token" in
        --)
          j=$((j + 1))
          break
          ;;
        -n|--namespace|--context|--kubeconfig|--server|--user|--cluster|--as|--as-group|--request-timeout|--cache-dir|--certificate-authority|--client-certificate|--client-key|--token)
          j=$((j + 2))
          ;;
        -n=*|--namespace=*|--context=*|--kubeconfig=*|--server=*|--user=*|--cluster=*|--as=*|--as-group=*|--request-timeout=*|--cache-dir=*|--certificate-authority=*|--client-certificate=*|--client-key=*|--token=*)
          j=$((j + 1))
          ;;
        -*)
          j=$((j + 1))
          ;;
        rollout)
          if [ $((j + 1)) -lt "${#tokens[@]}" ]; then
            printf '%s' "${tokens[$((j + 1))]}"
            return 0
          fi
          return 1
          ;;
        *)
          break
          ;;
      esac
    done
  done

  return 1
}

terraform_first_command() {
  local -a tokens
  local i
  local j
  local token
  read -r -d '' -a tokens <<< "$COMMAND_NORM" || true

  for i in "${!tokens[@]}"; do
    [ "${tokens[$i]##*/}" = "terraform" ] || continue
    j=$((i + 1))
    while [ "$j" -lt "${#tokens[@]}" ]; do
      token="${tokens[$j]}"
      case "$token" in
        --)
          j=$((j + 1))
          break
          ;;
        -chdir)
          j=$((j + 2))
          ;;
        -chdir=*|-help|--help|-version|--version)
          j=$((j + 1))
          ;;
        -*)
          j=$((j + 1))
          ;;
        *)
          printf '%s' "$token"
          return 0
          ;;
      esac
    done
    if [ "$j" -lt "${#tokens[@]}" ]; then
      printf '%s' "${tokens[$j]}"
      return 0
    fi
  done

  return 1
}

git_command_lines() {
  local -a tokens
  local i
  local j
  local token
  read -r -d '' -a tokens <<< "$COMMAND_NORM" || true

  for i in "${!tokens[@]}"; do
    [ "${tokens[$i]##*/}" = "git" ] || continue
    j=$((i + 1))
    while [ "$j" -lt "${#tokens[@]}" ]; do
      token="${tokens[$j]}"
      case "$token" in
        --)
          j=$((j + 1))
          break
          ;;
        -c|--git-dir|--work-tree|--namespace|--super-prefix|--config-env)
          j=$((j + 2))
          ;;
        -*)
          j=$((j + 1))
          ;;
        *)
          break
          ;;
      esac
    done
    if [ "$j" -lt "${#tokens[@]}" ]; then
      printf 'git %s\n' "${tokens[*]:$j}"
    fi
  done
}

INPUT="$(cat)"

if [ -z "$INPUT" ]; then
  deny "Blocked by pretooluse-guard: missing hook input cannot be evaluated safely"
fi

command -v jq >/dev/null 2>&1 || deny "Blocked by pretooluse-guard: jq is required to parse hook input safely"

TOOL_NAME="$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || true)"
COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"

if [ -z "$TOOL_NAME" ]; then
  deny "Blocked by pretooluse-guard: hook input JSON cannot be parsed safely"
fi

log "tool=$TOOL_NAME bash_command_received=$([ -n "$COMMAND" ] && printf yes || printf no)"

case "$TOOL_NAME" in
  Bash|PowerShell) ;;
  *)
    log "ALLOW: not Bash or PowerShell (tool=$TOOL_NAME)"
    exit 0
    ;;
esac

if [ -z "$COMMAND" ]; then
  log "ALLOW: empty command"
  exit 0
fi

COMMAND_LC="$(printf '%s' "$COMMAND" | tr -d '\000' | tr '[:upper:]' '[:lower:]')"

# Normalize obfuscation: empty-string concat (r""m, r''m), backslash escapes (\rm),
# and absolute-path prefixes (/usr/bin/kubectl -> kubectl). Dangerous commands
# that rely on these surface forms still match the rules below after normalization.
COMMAND_NORM="$(printf '%s' "$COMMAND_LC" \
  | sed -E 's/""//g' \
  | sed -E "s/''//g" \
  | sed -E 's/\\([a-zA-Z])/\1/g' \
  | sed -E 's/\\ / /g' \
  | sed -E 's,(^|[[:space:]])/[^[:space:]]*/([a-z][a-z0-9._-]*),\1\2,g')"

# deny_if_matches operates on COMMAND_LC. Add a parallel check on the normalized
# form so obfuscated surface forms hit the same rule.
deny_if_matches_norm() {
  local pattern="$1"
  local reason="$2"
  if printf '%s\n' "$COMMAND_NORM" | grep -Eq "$pattern"; then
    deny "$reason"
  fi
}

GIT_COMMAND_NORM="$(git_command_lines)"

deny_if_matches_git() {
  local pattern="$1"
  local reason="$2"
  if [ -n "$GIT_COMMAND_NORM" ] && printf '%s\n' "$GIT_COMMAND_NORM" | grep -Eq "$pattern"; then
    deny "$reason"
  fi
}

# --- obfuscation and indirection ---
# eval is almost never legitimate in AI-issued shell and is the primary vehicle
# for base64/hex-decoded payloads. Block outright; legitimate use can disable
# the guard for one session.
deny_if_matches '(^|[[:space:]]|;|&&|\|\|)eval([[:space:]]|$)' "Blocked by pretooluse-guard: eval is not allowed"
deny_if_matches_norm '(^|[[:space:]]|;|&&|\|\|)eval([[:space:]]|$)' "Blocked by pretooluse-guard: eval is not allowed"
# base64 -d piped into a shell or eval
deny_if_matches '(base64|xxd|openssl[[:space:]]+base64|openssl[[:space:]]+enc)[[:space:]].*-d.*\|[[:space:]]*(bash|sh|zsh|ksh|dash|eval)' "Blocked by pretooluse-guard: decoded payload piped to shell is not allowed"
# Variable-assigned destructive command, then dereferenced: R=rm; $R ...
deny_if_matches_norm '(^|[[:space:]]|;)[a-z_][a-z0-9_]*=(rm|kubectl|terraform|dd|mkfs|shred|wipe)([[:space:]]|;|$)' "Blocked by pretooluse-guard: aliasing a destructive command via variable is not allowed"

# --- terraform ---
deny_if_matches '(^|[[:space:]])terraform[[:space:]]+apply([[:space:]]|$)' "Blocked by pretooluse-guard: terraform apply is not allowed"
deny_if_matches '(^|[[:space:]])terraform[[:space:]]+destroy([[:space:]]|$)' "Blocked by pretooluse-guard: terraform destroy is not allowed"
deny_if_matches_norm '(^|[[:space:]])terraform[[:space:]]+apply([[:space:]]|$)' "Blocked by pretooluse-guard: terraform apply is not allowed"
deny_if_matches_norm '(^|[[:space:]])terraform[[:space:]]+destroy([[:space:]]|$)' "Blocked by pretooluse-guard: terraform destroy is not allowed"
terraform_command="$(terraform_first_command || true)"
if [ "$terraform_command" = "apply" ]; then
  deny "Blocked by pretooluse-guard: terraform apply is not allowed"
elif [ "$terraform_command" = "destroy" ]; then
  deny "Blocked by pretooluse-guard: terraform destroy is not allowed"
fi

# --- kubectl ---
deny_if_matches '(^|[[:space:]])kubectl[[:space:]]+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale|attach)([[:space:]]|$)' "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
deny_if_matches_norm '(^|[[:space:]])kubectl[[:space:]]+(apply|delete|patch|exec|cp|port-forward|scale|set|drain|cordon|uncordon|taint|label|annotate|replace|create|edit|debug|run|expose|autoscale|attach)([[:space:]]|$)' "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
deny_if_matches '(^|[[:space:]])kubectl[[:space:]]+rollout[[:space:]]+(restart|undo|pause|resume)([[:space:]]|$)' "Blocked by pretooluse-guard: kubectl rollout mutation is not allowed"
kubectl_command="$(kubectl_first_command || true)"
if token_in_list "$kubectl_command" apply delete patch exec cp port-forward scale set drain cordon uncordon taint label annotate replace create edit debug run expose autoscale attach; then
  deny "Blocked by pretooluse-guard: kubectl mutating command is not allowed"
fi
kubectl_rollout_subcommand="$(kubectl_rollout_command || true)"
if token_in_list "$kubectl_rollout_subcommand" restart undo pause resume; then
  deny "Blocked by pretooluse-guard: kubectl rollout mutation is not allowed"
fi

# --- remote script execution ---
if printf '%s\n' "$COMMAND_LC" | grep -Eq '(^|[[:space:]])(curl|wget)([[:space:]]|$)'; then
  if printf '%s\n' "$COMMAND_LC" | grep -Eq '(\||&&|;)[[:space:]]*(bash|sh|zsh|ksh|fish|powershell|pwsh)([[:space:]]|$)'; then
    deny "Blocked by pretooluse-guard: remote script execution is not allowed"
  fi
fi
# Two-stage remote execution: curl/wget writes a file, then bash/source runs it.
# Covers: `curl ... -o /tmp/x.sh && bash /tmp/x.sh`, `wget ... ; . /tmp/x.sh`,
# `curl ... > /tmp/x && sh /tmp/x`. Matches when a download+run pair shows up
# in a single shell invocation.
if printf '%s\n' "$COMMAND_LC" | grep -Eq '(curl|wget)[^|;&]*(-o|>)[[:space:]]*[^[:space:]]+'; then
  if printf '%s\n' "$COMMAND_LC" | grep -Eq '(;|&&|\|\|)[[:space:]]*(bash|sh|zsh|ksh|source|\.)[[:space:]]+'; then
    deny "Blocked by pretooluse-guard: two-stage remote script execution is not allowed"
  fi
fi
# `source file` or `. file` used to execute an arbitrary script (post-write bypass).
deny_if_matches '(^|;|&&|\|\|)[[:space:]]*(source|\.)[[:space:]]+/(tmp|var|dev)/[^[:space:]]+\.(sh|bash|zsh)' "Blocked by pretooluse-guard: sourcing a transient script is not allowed"

# --- .env secrets leak ---
deny_if_matches '(^|[[:space:]])cat[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
deny_if_matches_norm '(^|[[:space:]])cat[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
deny_if_matches '(^|[[:space:]])source[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: sourcing .env files is not allowed"
deny_if_matches_norm '(^|[[:space:]])source[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: sourcing .env files is not allowed"
deny_if_matches '(^|[[:space:]])(head|tail|less)[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
deny_if_matches_norm '(^|[[:space:]])(head|tail|less)[[:space:]]+[^[:space:]]*\.env([[:space:]]|$)' "Blocked by pretooluse-guard: reading .env files is not allowed"
deny_if_matches 'export[[:space:]]+\$\([[:space:]]*<[[:space:]]*[^)]*\.env' "Blocked by pretooluse-guard: exporting .env files is not allowed"

# --- shell injection ---
deny_if_matches '(^|[[:space:]])(bash|sh|zsh|ksh)[[:space:]]+-[^[:space:]]*c([[:space:]]|$)' "Blocked by pretooluse-guard: shell -c execution is not allowed"

# --- rm -rf ---
deny_if_matches '(^|[[:space:]])rm[[:space:]]+.*( *--recursive *--force| *--force *--recursive| *-[a-z]*r[a-z]*f| *-[a-z]*f[a-z]*r)' "Blocked by pretooluse-guard: rm -rf is not allowed"
deny_if_matches_norm '(^|[[:space:]])rm[[:space:]]+.*( *--recursive *--force| *--force *--recursive| *-[a-z]*r[a-z]*f| *-[a-z]*f[a-z]*r)' "Blocked by pretooluse-guard: rm -rf is not allowed"
# Split flags: rm -r -f OR rm -f -r (in either order, with other flags allowed between)
deny_if_matches_norm '(^|[[:space:]])rm[[:space:]]+(-[a-z]*r[a-z]*[[:space:]]+(-[a-z]*[[:space:]]+)*-[a-z]*f|-[a-z]*f[a-z]*[[:space:]]+(-[a-z]*[[:space:]]+)*-[a-z]*r|--recursive[[:space:]]+(-[^[:space:]]+[[:space:]]+)*--force|--force[[:space:]]+(-[^[:space:]]+[[:space:]]+)*--recursive)' "Blocked by pretooluse-guard: rm with recursive+force flags is not allowed"
deny_if_matches '(^|[[:space:]])rm[[:space:]]+(-[^[:space:]]*[[:space:]]+)*/([[:space:]]|\*|$)' "Blocked by pretooluse-guard: rm against root path is not allowed"
deny_if_matches_norm '(^|[[:space:]])rm[[:space:]]+(-[^[:space:]]*[[:space:]]+)*/([[:space:]]|\*|$)' "Blocked by pretooluse-guard: rm against root path is not allowed"

# --- filesystem and process destructive patterns ---
deny_if_matches '(^|[[:space:]])chmod[[:space:]].*(777|666|o\+[^[:space:]]*w|a\+[^[:space:]]*w)([[:space:]]|$)' "Blocked by pretooluse-guard: world-writable chmod is not allowed"
deny_if_matches '(^|[[:space:]])chown[[:space:]].*(-[^[:space:]]*r|--recursive).*root' "Blocked by pretooluse-guard: recursive chown to root is not allowed"
deny_if_matches '(^|[[:space:]])mkfs([[:space:]]|$)' "Blocked by pretooluse-guard: filesystem formatting is not allowed"
deny_if_matches '(^|[[:space:]])dd[[:space:]].*(if|of)=' "Blocked by pretooluse-guard: raw disk copy is not allowed"
deny_if_matches_norm '(^|[[:space:]])dd[[:space:]].*(if|of)=' "Blocked by pretooluse-guard: raw disk copy is not allowed"
deny_if_matches '>[[:space:]]*/dev/(sd|nvme|mapper|xvd|vd|mmcblk|loop|hd)' "Blocked by pretooluse-guard: writing to block devices is not allowed"
deny_if_matches_norm '>[[:space:]]*/dev/(sd|nvme|mapper|xvd|vd|mmcblk|loop|hd)' "Blocked by pretooluse-guard: writing to block devices is not allowed"
deny_if_matches '>[[:space:]]*/etc/' "Blocked by pretooluse-guard: overwriting system config is not allowed"
deny_if_matches '(^|[[:space:]])systemctl[[:space:]]+(-[^[:space:]]+[[:space:]]+)*(stop|restart|disable|mask)([[:space:]]|$)' "Blocked by pretooluse-guard: system service mutation is not allowed"
deny_if_matches '(^|[[:space:]])kill[[:space:]]+-9[[:space:]]+-1([[:space:]]|$)' "Blocked by pretooluse-guard: killing all processes is not allowed"
deny_if_matches '(^|[[:space:]])pkill[[:space:]]+-9([[:space:]]|$)' "Blocked by pretooluse-guard: force-killing processes is not allowed"
deny_if_matches ':\(\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:[[:space:]]*&[[:space:]]*\}[[:space:]]*;[[:space:]]*:' "Blocked by pretooluse-guard: fork bomb pattern is not allowed"
deny_if_matches '(^|[[:space:]])xargs[[:space:]].*(^|[[:space:]])rm([[:space:]]|$)' "Blocked by pretooluse-guard: xargs rm is not allowed"
deny_if_matches '(^|[[:space:]])find[[:space:]].*-exec[[:space:]]+([^[:space:]]*/)?rm([[:space:]]|$)' "Blocked by pretooluse-guard: find -exec rm is not allowed"
deny_if_matches '(^|[[:space:]])find[[:space:]].*-delete([[:space:]]|$)' "Blocked by pretooluse-guard: find -delete is not allowed"
deny_if_matches '(^|[[:space:]])rsync[[:space:]].*--delete([-_[:alpha:]]*)?([[:space:]]|=|$)' "Blocked by pretooluse-guard: rsync --delete is not allowed"
deny_if_matches '(^|[[:space:]])shred([[:space:]]|$)' "Blocked by pretooluse-guard: shred is not allowed"
deny_if_matches '(^|[[:space:]])wipe([[:space:]]|$)' "Blocked by pretooluse-guard: wipe is not allowed"

# --- git destructive ---
deny_if_matches '(^|[[:space:]])git[[:space:]]+push[[:space:]].*(--force|--force-with-lease|-f)([[:space:]]|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
deny_if_matches_norm '(^|[[:space:]])git[[:space:]]+push[[:space:]].*(--force|--force-with-lease|-f)([[:space:]]|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+push[[:space:]].*(--force|--force-with-lease|-f)([[:space:]]|$)' "Blocked by pretooluse-guard: git push --force is not allowed"
# Force-push alternative: refspec with + prefix (e.g. git push origin +main)
deny_if_matches '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
deny_if_matches_norm '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+\+[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push with + refspec is force-push and is not allowed"
# Colon-syntax remote ref deletion (git push origin :branch deletes the remote branch)
deny_if_matches '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
deny_if_matches_norm '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+push([[:space:]]+[^[:space:]]+)*[[:space:]]+:[a-z0-9._/-]+' "Blocked by pretooluse-guard: git push colon-ref deletion is not allowed"
deny_if_matches '(^|[[:space:]])git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)' "Blocked by pretooluse-guard: git reset --hard is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)' "Blocked by pretooluse-guard: git reset --hard is not allowed"
deny_if_matches '(^|[[:space:]])git[[:space:]]+clean[[:space:]]+-[^[:space:]]*f' "Blocked by pretooluse-guard: git clean -f is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+clean[[:space:]]+-[^[:space:]]*f' "Blocked by pretooluse-guard: git clean -f is not allowed"
deny_if_matches '(^|[[:space:]])git[[:space:]]+branch[[:space:]]+-d([[:space:]]|$)' "Blocked by pretooluse-guard: git branch delete is not allowed"
deny_if_matches_git '(^|[[:space:]])git[[:space:]]+branch[[:space:]]+-d([[:space:]]|$)' "Blocked by pretooluse-guard: git branch delete is not allowed"

# --- aws destructive ---
# The settings layer only "asks" for these; at hook level we want a hard block
# on the clearly irreversible ones so an accidental approval can't wipe state.
deny_if_matches '(^|[[:space:]])aws[[:space:]]+s3[[:space:]]+rb[[:space:]].*--force' "Blocked by pretooluse-guard: aws s3 rb --force is not allowed"
deny_if_matches '(^|[[:space:]])aws[[:space:]]+s3[[:space:]]+rm[[:space:]].*--recursive' "Blocked by pretooluse-guard: aws s3 rm --recursive is not allowed"
deny_if_matches '(^|[[:space:]])aws[[:space:]]+(iam|rds|dynamodb|cloudformation|ec2|eks|ecr|secretsmanager|ssm|kms|s3api|lambda|logs|sns|sqs|route53|cloudfront|elbv2|elb|efs|sagemaker|glue|redshift)[[:space:]]+delete-' "Blocked by pretooluse-guard: aws delete-* is not allowed"
deny_if_matches '(^|[[:space:]])aws[[:space:]]+s3api[[:space:]]+(delete-object|delete-bucket|put-bucket-policy)' "Blocked by pretooluse-guard: aws s3api destructive is not allowed"
deny_if_matches '(^|[[:space:]])aws[[:space:]]+lambda[[:space:]]+(delete-function|delete-alias|remove-permission)' "Blocked by pretooluse-guard: aws lambda destructive is not allowed"
deny_if_matches '(^|[[:space:]])aws[[:space:]]+rds[[:space:]]+(delete-db-instance|delete-db-cluster|delete-db-snapshot)' "Blocked by pretooluse-guard: aws rds destructive is not allowed"

# --- gcloud destructive ---
deny_if_matches '(^|[[:space:]])gcloud[[:space:]]+([a-z-]+[[:space:]]+)+delete([[:space:]]|$)' "Blocked by pretooluse-guard: gcloud delete is not allowed"
deny_if_matches '(^|[[:space:]])gcloud[[:space:]]+projects[[:space:]]+delete' "Blocked by pretooluse-guard: gcloud projects delete is not allowed"
deny_if_matches '(^|[[:space:]])gcloud[[:space:]]+iam[[:space:]]+service-accounts[[:space:]]+delete' "Blocked by pretooluse-guard: gcloud service-account delete is not allowed"
deny_if_matches '(^|[[:space:]])gcloud[[:space:]]+([a-z-]+[[:space:]]+)+remove-iam-policy-binding' "Blocked by pretooluse-guard: gcloud remove-iam-policy-binding is not allowed"
deny_if_matches '(^|[[:space:]])gcloud[[:space:]]+storage[[:space:]]+rm[[:space:]]+.*--recursive' "Blocked by pretooluse-guard: gcloud storage rm --recursive is not allowed"

# --- docker privileged / host-mount escape ---
deny_if_matches '(^|[[:space:]])docker[[:space:]]+run[[:space:]].*--privileged([[:space:]]|$)' "Blocked by pretooluse-guard: docker run --privileged is not allowed"
# Host-root volume mount turns any container into a host-rewrite shell:
# `docker run -v /:/host ... rm /host/...`. Block at the mount pattern.
deny_if_matches '(^|[[:space:]])docker[[:space:]]+run[[:space:]].*(-v|--volume)[=[:space:]]+/(:|/)' "Blocked by pretooluse-guard: docker host-root volume mount is not allowed"
deny_if_matches_norm '(^|[[:space:]])docker[[:space:]]+run[[:space:]].*(-v|--volume)[=[:space:]]+/(:|/)' "Blocked by pretooluse-guard: docker host-root volume mount is not allowed"

# --- inline interpreter execution (promoted from strict to standard) ---
# Inline python/perl/ruby/node can bypass every shell-pattern rule above
# (e.g. `python -c "import shutil; shutil.rmtree('/')"`). This blocks the
# vehicle, not the payload.
if [ "$HOOK_PROFILE" != "minimal" ]; then
  deny_if_matches '(^|[[:space:]])(python[23]?|perl|ruby|node)[[:space:]]+-[ec][[:space:]]+' "Blocked by pretooluse-guard: inline script execution is not allowed"
  deny_if_matches_norm '(^|[[:space:]])(python[23]?|perl|ruby|node)[[:space:]]+-[ec][[:space:]]+' "Blocked by pretooluse-guard: inline script execution is not allowed"
  deny_if_matches '(^|[[:space:]])(python[23]?|perl|ruby|node)[[:space:]]+<<' "Blocked by pretooluse-guard: heredoc script execution is not allowed"
  deny_if_matches_norm '(^|[[:space:]])(python[23]?|perl|ruby|node)[[:space:]]+<<' "Blocked by pretooluse-guard: heredoc script execution is not allowed"
fi

log "ALLOW: no rule matched"
exit 0
