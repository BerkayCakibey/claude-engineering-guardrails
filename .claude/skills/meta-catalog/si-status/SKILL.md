---
name: "si-status"
description: "Knowledge health dashboard showing file counts, capacity, stale entries, and recommendations. Use when: checking knowledge health, capacity, or before deciding whether to run si-review."
command: /si-status
---

# Skill: si-status

## Purpose
Provide a quick health dashboard for optional local project knowledge, rule
surfaces, and
stale-reference risk. This is the command-backed status workflow for deciding
whether deeper review is needed.

## Command Alias

Primary command:

```text
/si-status [--brief]
```

Prefer the command alias when the user wants a health snapshot or capacity
check. Use `si-review` when the task needs full candidate analysis.

## Trigger Conditions

Use this skill when:
- checking knowledge capacity or growth
- deciding whether a full `si-review` is worth running
- verifying whether knowledge files or rules have become stale or oversized

## Input Boundary

Inspect only the status surfaces:
- `.claude/knowledge/*.md` when the optional local knowledge store exists
- project `CLAUDE.md`
- optional `~/.claude/CLAUDE.md` if accessible
- `.claude/rules/*.md`

Optional mode:
- `--brief`

## Step Order (Mandatory)

1. Locate the knowledge, rule, and project instruction files. If the optional
   local knowledge store is absent, report that first instead of assuming it
   should exist.
2. Count knowledge files, total lines, and rule files.
3. Run a lightweight stale-reference pass where file paths are explicitly
   mentioned.
4. Classify the health state as healthy, warning, or critical.
5. Keep the result metric-driven; do not turn this status check into a full
   audit.
6. Recommend `si-review` only when the status signals justify it.

## Evidence Expectations

- State the file counts and line counts used for the status summary.
- State the basis for any stale-reference warning.
- Keep the output at dashboard level; do not dump raw knowledge content.

## Non-Goals

- Do not quote or expose knowledge-entry contents that may contain secrets.
- Do not perform a full promotion-candidate analysis here.
- Do not mutate knowledge files or rules in the status step.
- Do not overstate precision when only a quick stale check was performed.

## Output Format

1. STATUS MODE

State whether the run was full or `--brief`.

2. KNOWLEDGE DASHBOARD

State counts for knowledge files, knowledge size, `CLAUDE.md`, and rules.

3. HEALTH CLASSIFICATION

State healthy, warning, or critical and why.

4. STALE-SURFACE NOTES

State any stale-reference indicators or redaction warnings.

5. NEXT STEP

State whether to run `si-review`, clean up entries, or stop.
