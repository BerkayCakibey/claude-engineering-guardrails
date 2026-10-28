---
name: docker-patterns
description: >-
  Work with Dockerfiles and Compose setups using least-privilege, reproducible build patterns.
---

# Skill: docker-patterns

## Purpose
Work with Dockerfiles and Compose setups using least-privilege, reproducible build patterns. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: work with Dockerfiles and Compose setups using least-privilege, reproducible build patterns.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `terminal-backend-patterns`.
- The main risk has shifted to an adjacent concern outside this card. Use `security-scan`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Review work with Dockerfiles and Compose setups using least-privilege, reproducible build patterns with rollback, sequencing, and blast radius in view.
2. Name the destructive edge explicitly before proposing a migration or runtime change.
3. Prefer reversible or staged steps when data or environment state can drift.
4. Escalate to `terminal-backend-patterns` when the change becomes a full implementation lane.

## Evidence To Collect
- schema, container, or environment baseline
- ordered steps with rollback notes
- the exact validation command or read-only proof after the change

## Related Skills
- Primary broader workflow: `terminal-backend-patterns`
- Adjacent boundary: `security-scan`
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
