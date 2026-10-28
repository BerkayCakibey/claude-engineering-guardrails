---
name: context-budget
description: >-
  Plan token budgets and context carry-forward before large tasks or long sessions.
---

# Skill: context-budget

## Purpose
Plan token budgets and context carry-forward before large tasks or long sessions. Treat this as a narrow pattern card: reserve context for the highest-risk work, keep only what later phases need, and compact deliberately before the thread becomes lossy.

## Use When
- The task is large enough that context loss or token waste will change outcome quality.
- The work spans retrieval, implementation, verification, or handoff phases that compete for limited context.
- You need an explicit compact trigger before the session accumulates too much state.

## Do Not Use When
- The task only needs one focused retrieval pass into prior work. Use `mem-search`.
- The main need is mapping current code structure before editing. Use `smart-explore`.
- The result should become a durable reusable corpus or documentation surface. Use `knowledge-ops`.

## Focus Checklist
1. Classify the task as lookup, review, implementation, verification, or handoff.
2. Reserve context for the highest-risk phase before opening broad material.
3. Use `mem-search` and `smart-explore` to discover candidates before loading full files.
4. Keep only the carry-forward state that changes later behavior: decisions, touched files, commands, and risks.
5. Compact deliberately with `strategic-compact` before the session becomes lossy.

## Evidence To Collect
- the chosen budget class and the phase that needs reserved context
- the must-keep files, commands, artifacts, or decisions for the next phase
- the explicit compact trigger or stop rule

## Related Skills
- Primary broader workflow: `task-dispatcher`
- Adjacent boundary: `strategic-compact`
- Use `mem-search` and `smart-explore` to discover before loading more context

Reference workflow: `../mem-search/references/retrieval-ladder.md`.

## Group
Memory And Context

## Output Contract
```markdown
## Budget Class
- [lookup, review, implementation, verification, or handoff]

## Reserved Context
- [files, decisions, artifacts, and why they must stay in scope]

## Compact Trigger
- [when to compact or stop reading more]

## Risks
- [remaining uncertainty or follow-up]
```
