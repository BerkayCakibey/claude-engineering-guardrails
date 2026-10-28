---
name: python-security-review
description: Review Python code for security risks, unsafe patterns, and exposure of secrets or dangerous behavior
argument-hint: "[file, module, or change to review]"
disable-model-invocation: false
---

# Skill: python-security-review

## Purpose
Review Python code for security risks, unsafe execution paths, secret exposure,
and insecure defaults with evidence strong enough to separate real issues from
generic warning noise.

## Use When
- The user asks for a Python security review.
- A Python file, module, diff, hook, script, or bounded repo surface needs
  security-specific review.
- The change touches trust boundaries such as subprocesses, auth, file access,
  network calls, or deserialization.

## Review Workflow
1. Identify the exact review scope and trust boundaries involved.
2. Inspect the code paths that handle input, commands, files, secrets, auth,
   network access, and serialization.
3. If the scope is a repo, PR, CI, hook, or automation surface, also apply
   `skill-security-auditor/references/repo-security-scan-gates.md`.
4. Separate confirmed exploitable paths from static pattern leads.
5. Redact any credential-like values instead of reproducing them.

## Review Gates
### Code Execution And Process Safety
- no unsafe `eval`, `exec`, or shell command construction
- subprocess usage does not create injection or privilege-escalation paths

### Secrets And Sensitive Data
- no hardcoded secrets, keys, tokens, or credential files
- logs and exceptions do not leak sensitive values
- `.env` or environment-variable handling is not careless or over-trusting

### File, Network, And Serialization Safety
- file paths are validated and normalized where attacker-controlled input exists
- network calls use sane destination and timeout handling
- unsafe deserialization patterns are avoided or tightly constrained

### Auth And Runtime Defaults
- authentication, token handling, and authorization assumptions are explicit
- production-like defaults are not insecure by convenience

## Evidence Contract
- cite concrete file or diff locations for each finding
- explain when the issue is exploitable and what boundary it crosses
- distinguish confirmed vulnerabilities from static suspicion
- keep all credential-like values redacted

## Output Requirements
```markdown
## Scope
- [file, module, or change reviewed]

## Findings
- Severity: CRITICAL | HIGH | MEDIUM | LOW
- Location: path:line or diff section
- Issue: [concrete security problem]
- Exploit Path: [how it becomes risky]
- Fix Direction: [smallest useful mitigation]

## Secret Exposure Review
- [whether secrets, tokens, keys, or unsafe credential handling were found]

## Safe-Usage Verdict
- [local only, internal tooling only, or not safe before fixes]

## Evidence
- [files, diffs, gates, and reasoning basis]
```
