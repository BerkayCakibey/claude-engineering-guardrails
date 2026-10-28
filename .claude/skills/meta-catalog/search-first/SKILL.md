---
name: search-first
description: >-
  Search documentation, source, and prior decisions before inventing implementation details.
---

# Skill: search-first

## Purpose
Search documentation, source, and prior decisions before inventing implementation details. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: search documentation, source, and prior decisions before inventing implementation details.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `repo-navigator`.
- The main risk has shifted to an adjacent concern outside this card. Use `mem-search`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Start from the concrete failure mode or waste pattern inside search documentation, source, and prior decisions before inventing implementation details.
2. Prefer the lightest mechanism that closes the risk instead of adding framework weight.
3. Make false-green, hidden-cost, or policy-bypass paths explicit.
4. Escalate to `repo-navigator` when the problem stops being a narrow review card and becomes an end-to-end workflow.

## Evidence To Collect
- representative inputs, failures, or cost numbers
- one before/after path showing what improves
- a concrete check, report, or metric that proves the card helped

## Related Skills
- Primary broader workflow: `repo-navigator`
- Adjacent boundary: `mem-search`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Engineering Workflow

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
