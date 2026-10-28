---
name: safety-guard
description: >-
  Activate extra caution for destructive commands, production data, credentials, and irreversible actions.
---

# Skill: safety-guard

## Purpose
Force a stricter operating mode before high-trust or hard-to-undo actions.

## Use When
- The task touches production, credentials, customer data, or irreversible state.
- A command looks technically possible but operationally expensive to get wrong.
- The user wants a preflight before infra, data, or safety-sensitive work.

## Preflight Checklist
1. Identify the environment, account, namespace, or data boundary.
2. State the exact risky action being considered.
3. State whether the action is reversible, partially reversible, or irreversible.
4. Name the verification command or observation that would prove safety.
5. If hooks or permission prompts fire, stop and surface the block rather than searching for a bypass.

## Decision Modes
- **Allow**: read-only or easily reversible with low blast radius
- **Ask**: meaningful risk exists but the user can choose explicitly
- **Abort**: unclear trust boundary, secret exposure, destructive bypass, or unjustified irreversible action

## Output Requirements
```markdown
## Trust Boundary
- [env, data, credentials, systems]

## Risk Classification
- Level: LOW | MEDIUM | HIGH
- Why: [specific failure mode]

## Safe Path
- [smallest acceptable next step]

## Verification
- [command, artifact, or human check required]
```

## Group
Product Design And QA
