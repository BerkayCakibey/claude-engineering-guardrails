# Retrieval Ladder

Use this reference when a task may benefit from prior work, old decisions,
saved notes, commit history, or generated scan output.

## Layer 1: Search Index

Goal: find candidate context without spending the budget.

Preferred sources:

- `rg` results
- generated indexes
- `git log --oneline`
- filenames and headings
- manifest/catalog metadata
- short local status output

Stop here when a filename, command, or prior decision is enough to proceed.

## Layer 2: Timeline

Goal: reconstruct the narrow sequence that matters.

Capture:

- decision or bug chronology
- affected files
- commit subjects or local notes
- validation commands and outcomes
- open risks or deferred work

Stop here when the user needs a status answer, handoff, or small next step.

## Layer 3: Selected Observations

Goal: load only the details needed for the next action.

Pull:

- the specific code block
- the exact config entry
- the relevant test assertion
- the local report section
- the command output that proves or disproves a claim

Do not pull whole transcripts, catalogs, or large files unless the earlier
layers prove that the broad context is required.

## Decision Rules

- If the task is exploratory, stay in Layer 1 until a concrete target exists.
- If the task asks "what happened?", use Layer 2 before editing.
- If the task asks for a fix, use Layer 3 only for the files being changed.
- If a memory conflicts with the current repo, the current repo wins.
- If the evidence is missing, label the result as an assumption.

## Handoff Shape

```markdown
## Query
- [what was searched]

## Timeline
- [decision or file sequence]

## Selected Observations
- [only the details used]

## Next Action
- [edit, test, ask, or stop]
```
