---
name: mem-search
description: >-
  Search prior work through a three-layer index, timeline, and detail retrieval workflow.
---

# Skill: mem-search

## Purpose
Search prior work through the repo's three-layer Retrieval Ladder: index, timeline, then selected observations. Treat this as a narrow pattern card: recover just enough history to answer the current question, then hand back to the broader workflow.

## Use When
- You need earlier decisions, validation evidence, or implementation context before acting now.
- Cheap repo search found likely prior work, but the answer still depends on history rather than only current files.
- You want a repeatable way to stop at the first retrieval layer that resolves the question.

## Do Not Use When
- The task is mainly about mapping the current codebase structure before editing. Use `smart-explore`.
- The work should become durable reusable knowledge, not just one retrieval pass. Use `knowledge-ops`.
- A single local grep or file lookup is enough to answer the question. Use `search-first`.

## Focus Checklist
1. Name the retrieval question, repo/product scope, and stop condition before reading broad history.
2. Start at Layer 1 of the Retrieval Ladder: names, paths, commit subjects, headings, and short summaries.
3. Escalate to Layer 2 only when you need the narrow sequence of decisions, changed files, or validation evidence.
4. Pull Layer 3 observations only for the exact files, commands, or decisions required now.
5. Verify the memory hit against the current repository state before treating it as authoritative.

## Evidence To Collect
- the search terms, memory source, or index hits that justified retrieval
- the minimal timeline slice that answers the question
- the exact file, command, or commit evidence that still matches current state

## Related Skills
- Primary broader workflow: `knowledge-ops`
- Adjacent boundary: `smart-explore`
- Use `search-first` first when one cheap current-state lookup may already be enough

Reference workflow: `references/retrieval-ladder.md`.

## Group
Memory And Context

## Output Contract
```markdown
## Retrieval Decision
- [question, chosen layer, and stop condition]

## Retrieved Evidence
- [timeline slice, files, commits, or notes recovered]

## Current-State Check
- [what was re-verified against the live repository]

## Next Step
- [answer, escalate, or stop]
```
