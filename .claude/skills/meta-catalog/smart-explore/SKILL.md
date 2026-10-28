---
name: smart-explore
description: >-
  Explore large codebases through search, outlines, and targeted unfolding before reading full files.
---

# Skill: smart-explore

## Purpose
Explore large codebases through search, outlines, and targeted unfolding before reading full files. Treat this as a narrow pattern card: map just enough structure to unblock the next answer or edit, then hand back to the broader workflow.

## Use When
- You need to understand an unfamiliar module, entry point, or data path before editing or reviewing it.
- Broad file reads would be noisy, but path-level tracing can answer the current question.
- You want a repeatable stopping rule so exploration does not sprawl into unrelated modules.

## Do Not Use When
- The main need is past decisions or historical context rather than the live codebase. Use `mem-search`.
- The task needs an end-to-end implementation or review workflow. Use `repo-navigator`.
- The result should be stored as durable reusable knowledge rather than a one-off exploration trace. Use `knowledge-ops`.

## Focus Checklist
1. Map the surface first with `rg --files`, generated manifests, or repo-native indexes.
2. Search for concrete identifiers, commands, config keys, validation checks, and entry points.
3. Build one path trace: entry point, transformations, side effects, tests, and docs.
4. Open full files only after snippets or nearby examples stop being enough.
5. Stop once the next edit, answer, or escalation path is concrete enough to verify.

## Evidence To Collect
- the mapped paths or module boundary that scoped the exploration
- one traced flow that proves how the relevant surface works
- the exact files, snippets, tests, or docs that support the trace

## Related Skills
- Primary broader workflow: `repo-navigator`
- Adjacent boundary: `mem-search`
- Use `knowledge-ops` only when the findings need to become durable corpus material

## Group
Memory And Context

## Output Contract
```markdown
## Surface Map
- [candidate files, entry points, or modules]

## Trace
- [path-level explanation of how the relevant surface works]

## Evidence
- [checks, files, commands, or artifacts]

## Next Step
- [edit, escalate, or stop]
```
