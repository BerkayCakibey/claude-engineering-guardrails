---
name: knowledge-ops
description: >-
  Build and query focused knowledge corpora from prior work without flooding current context.
---

# Skill: knowledge-ops

## Purpose
Build and query focused knowledge corpora from prior work without flooding
current context. Use this skill when the result should become durable reusable
repository knowledge rather than a one-off retrieval pass.

## Trigger Conditions

Use this skill when:
- the result should become reusable repository knowledge, durable docs,
  catalogs, reports, or other persistent context
- a pattern, decision history, or operating rule must survive the current
  thread and be queryable later
- `mem-search`, `smart-explore`, `strategic-compact`, or `continuous-learning`
  surfaced findings that should now be organized into a maintained corpus

Use a narrower memory skill instead when:
- the task is only a one-off historical lookup -> `mem-search`
- the task is only live codebase exploration -> `smart-explore`
- the task is only context budgeting or compaction -> `context-budget` or
  `strategic-compact`

## Input Boundary

The user may provide:
- a repository, product, incident, or decision area
- prior notes, reports, commits, docs, or timelines
- an explicit request to organize, update, or query durable knowledge

Inspect only the corpus surfaces needed for the active knowledge task:
- source docs, reports, notes, or generated summaries
- the repository state needed to verify current truth
- retrieval aids such as the Retrieval Ladder reference

## Step Order (Mandatory)

1. Identify the repository, product, or decision boundary the corpus should
   cover.
2. Define the knowledge goal: retrieve, organize, update, or promote durable
   knowledge.
3. Use Layer 1 search first, then Layer 2 timeline reconstruction, then Layer
   3 observations only as needed.
4. Separate summaries, indexes, timelines, and observations so future
   retrieval can stop early.
5. Verify any reusable fact against the current repository or product state
   before storing it as durable knowledge.
6. Update the corpus only when the new fact, summary, or structure is likely
   to be reused later.
7. Report what was queried, what changed, and what remains uncertain.

## Corpus Rules

- Build focused corpora around one product, repository, incident, or decision class.
- Store summaries, indexes, and observations separately so retrieval can stop early.
- Prefer durable local files over hidden chat-only state when the knowledge must survive.
- Redact secrets and personal data before writing reusable knowledge.
- Mark generated or inferred observations explicitly; do not mix them with verified facts.

## Evidence Expectations

- State the corpus boundary and the retrieval or update goal.
- State which notes, reports, files, or timelines were inspected.
- Distinguish verified facts from inferred observations.
- State what durable artifact or corpus update was created or revised.

Reference workflow: `../mem-search/references/retrieval-ladder.md`.

## Non-Goals

- Do not treat one-off retrieval as durable knowledge curation.
- Do not store credentials, secrets, or personal data in reusable corpora.
- Do not mix verified facts with speculation or generated observations.
- Do not update broad knowledge surfaces when the finding is unlikely to be
  reused.
- Do not skip current-state verification for facts that influence later work.

## Group
Memory And Context

## Output Format
```markdown
## Corpus Scope
- [repository, product, incident, or decision area]

## Knowledge Goal
- [retrieve, organize, update, or promote]

## Findings Or Corpus Update
- [timeline slice, summaries, observations, and durable changes made]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]

## Next Step
- [query again, route to a narrower skill, or stop]
```
