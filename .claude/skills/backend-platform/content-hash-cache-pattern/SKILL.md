---
name: content-hash-cache-pattern
description: >-
  Use content hashes to cache expensive extraction, analysis, and generation steps safely.
---

# Skill: content-hash-cache-pattern

## Purpose
Use content hashes to cache expensive extraction, analysis, and generation steps safely. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: use content hashes to cache expensive extraction, analysis, and generation steps safely.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `cost-aware-llm-pipeline`.
- The main risk has shifted to an adjacent concern outside this card. Use `eval-harness`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Start from the concrete failure mode or waste pattern inside use content hashes to cache expensive extraction, analysis, and generation steps safely.
2. Prefer the lightest mechanism that closes the risk instead of adding framework weight.
3. Make false-green, hidden-cost, or policy-bypass paths explicit.
4. Escalate to `cost-aware-llm-pipeline` when the problem stops being a narrow review card and becomes an end-to-end workflow.

## Evidence To Collect
- representative inputs, failures, or cost numbers
- one before/after path showing what improves
- a concrete check, report, or metric that proves the card helped

## Related Skills
- Primary broader workflow: `cost-aware-llm-pipeline`
- Adjacent boundary: `eval-harness`
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
