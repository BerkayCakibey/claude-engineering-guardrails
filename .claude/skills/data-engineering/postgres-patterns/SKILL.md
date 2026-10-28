---
name: postgres-patterns
description: >-
  Apply PostgreSQL schema, query, indexing, transaction, and migration patterns safely.
---

# Skill: postgres-patterns

## Purpose
Apply PostgreSQL schema, query, indexing, transaction, and migration patterns safely. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: apply PostgreSQL schema, query, indexing, transaction, and migration patterns safely.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `database-migrations`.
- The main risk has shifted to an adjacent concern outside this card. Use `repo-navigator`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Review indexing, lock scope, transaction shape, migration order, and query-plan implications before proposing schema changes.
2. Call out resource ownership, data shape, and failure handling explicitly.
3. Prefer the smallest pattern that survives code review and team maintenance.
4. Hand off to `database-migrations` when the task becomes actual implementation instead of a pattern choice.

## Evidence To Collect
- current query or migration shape plus the index or lock behavior that justifies the recommendation
- one recommended pattern with its tradeoff
- the specific review or test signal that would prove the choice

## Related Skills
- Primary broader workflow: `database-migrations`
- Adjacent boundary: `repo-navigator`
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
