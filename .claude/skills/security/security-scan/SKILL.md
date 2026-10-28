---
name: security-scan
description: >-
  Run a repo-level security scan workflow that separates confirmed findings from static leads and noise.
---

# Skill: security-scan

## Purpose
Run a disciplined repo-level security review without turning every static pattern into a bug.

## Use When
- The user asks for a security scan or repository hardening pass.
- A repo needs a first-pass review before deeper SAST lane escalation.
- You need to distinguish confirmed risk from pattern noise quickly.

## Scan Workflow
1. Map the trust boundaries: auth, secrets, filesystem, subprocess, network, persistence.
2. Run the smallest useful repo scan first.
3. Split outputs into:
   - confirmed issue
   - likely issue needing proof
   - static lead / noise
4. Escalate to specialist SAST lanes only when evidence justifies it.
5. End with a fix order, not just a pile of grep hits.

## Review Gates
- no secret values or sample credentials in tracked files
- no unsafe subprocess or shell bridges without input control
- no obvious auth or authorization gaps in exposed paths
- no dependency/security claims without evidence
- no report wording that upgrades suspicion into fact

## Output Requirements
```markdown
## Scope
- [repo surface and trust boundaries]

## Confirmed Findings
- Severity: HIGH | MEDIUM | LOW
- Location: path:line
- Issue: [confirmed problem]
- Fix direction: [minimal correction]

## Static Leads
- [patterns that need proof before calling them bugs]

## Evidence
- [files, commands, tool output, reasoning basis]
```

## Group
Security And SAST
