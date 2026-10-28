---
name: strategic-compact
description: >-
  Prepare deliberate compact summaries that preserve decisions, files, risks, and next steps.
---

# Skill: strategic-compact

## Purpose
Prepare deliberate compact summaries that preserve only the state future work actually depends on. Treat this as a narrow pattern card: compact the thread deliberately, keep the parts that change later behavior, and drop the narration that can be rediscovered.

## Use When
- The thread already has multiple phases, commands, or decisions and a later step depends on that exact state.
- Context is approaching the point where command output, touched files, or deferred work may be lost.
- The user asks for a continuation-ready status that must survive compaction or handoff.

## Do Not Use When
- The main task is planning token budgets before work starts. Use `context-budget`.
- The missing information is still historical retrieval, not compaction. Use `mem-search`.
- The result should become durable reusable repository knowledge instead of a continuation block. Use `knowledge-ops`.

## Focus Checklist
1. Preserve user constraints, explicit decisions, branch state, and push restrictions.
2. Keep changed files, why they changed, and the commands that passed or failed.
3. Record deferred work, blockers, and open decisions that affect the next turn.
4. Drop duplicate output, stale failed attempts, and broad source material that can be rediscovered through `mem-search`.
5. Keep caveats factual; separate verified state from inference.

## Evidence To Collect
- the exact files, branches, commits, or artifacts that must survive compaction
- the validation commands and outcomes that define current state
- the unresolved risks or next steps that would otherwise be lost

## Related Skills
- Primary broader workflow: `context-budget`
- Adjacent boundary: `prompt-thinning`
- Use `knowledge-ops` when the compacted result should be promoted into durable reusable knowledge

Reference workflow: `../mem-search/references/retrieval-ladder.md`.

## Group
Memory And Context

## Output Contract
```markdown
## Surviving State
- [decisions, files, branch/commit state, and deferred work]

## Validation
- [commands run and whether they passed]

## Risks
- [remaining blockers, caveats, or follow-up]

## Next Step
- [resume point or handoff target]
```
