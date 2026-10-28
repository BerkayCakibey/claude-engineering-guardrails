---
name: harness-optimization
description: >-
  Audit AI harness startup cost, hook load, model routing, and component bloat.
---

# Skill: harness-optimization

## Purpose
Audit AI harness startup cost, hook load, model routing, and component bloat. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: audit AI harness startup cost, hook load, model routing, and component bloat.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `selective-install`.
- The main risk has shifted to an adjacent concern outside this card. Use `context-budget`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Start from the concrete failure mode or waste pattern inside audit AI harness startup cost, hook load, model routing, and component bloat.
2. Prefer the lightest mechanism that closes the risk instead of adding framework weight.
3. Make false-green, hidden-cost, or policy-bypass paths explicit.
4. Escalate to `selective-install` when the problem stops being a narrow review card and becomes an end-to-end workflow.

## Evidence To Collect
- representative inputs, failures, or cost numbers
- one before/after path showing what improves
- a concrete check, report, or metric that proves the card helped

## Related Skills
- Primary broader workflow: `selective-install`
- Adjacent boundary: `context-budget`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Harness And Agent Mechanics

## Output Contract
```markdown
## Decision
- [recommended pattern, constraint, or next move]

## Risks
- [main failure or tradeoff]

## Evidence
- [files, commands, examples, metrics, or assumptions]

## Next Step
- [implement, escalate, or stop]
```
