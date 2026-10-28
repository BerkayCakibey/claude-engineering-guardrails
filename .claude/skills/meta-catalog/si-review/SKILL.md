---
name: "si-review"
description: "Analyze knowledge files for promotion candidates, stale entries, consolidation opportunities, and health metrics. Use when: knowledge files are getting large, after a major feature, or weekly during active development."
command: /si-review
---

# Skill: si-review

## Purpose
Audit optional local project knowledge files for promotion candidates, stale entries,
consolidation opportunities, and rule conflicts. This is the command-backed
review workflow for the self-improvement surface.

## Command Alias

Primary command:

```text
/si-review [--quick|--stale|--candidates]
```

Prefer the command alias when the user explicitly wants a knowledge audit or a
focused review mode. Use `self-improving-agent` instead when the task spans
multiple `si-*` commands.

## Trigger Conditions

Use this skill when:
- knowledge files are growing large or noisy
- the user wants promotion candidates, stale-entry detection, or health
  metrics
- a recent feature or debugging session may have created reusable patterns
- a periodic knowledge audit is needed before promotion or extraction

## Input Boundary

Inspect only the surfaces needed for the review:
- `.claude/knowledge/*.md` when the optional local knowledge store exists
- project `CLAUDE.md`
- `.claude/rules/`

Optional user modifiers:
- `--quick`
- `--stale`
- `--candidates`

## Step Order (Mandatory)

1. Locate the project knowledge directory and count the knowledge files. If it
   does not exist, report that the optional local knowledge store is absent and
   stop.
2. Read the relevant knowledge files for the selected review mode.
3. Cross-reference against project `CLAUDE.md` and `.claude/rules/`.
4. Classify findings into:
   - promotion candidates
   - stale entries
   - consolidation opportunities
   - conflicts
   - health metrics
5. Verify any file-path staleness claims against the live repository.
6. Redact any credential-like content instead of reproducing it.
7. Produce a concise report with the top actionable recommendations.

## Evidence Expectations

- State which knowledge, rule, and policy files were inspected.
- State why an entry is stale, conflicting, duplicated, or promotion-worthy.
- When reporting staleness or conflict, cite the exact file or rule surface.
- Keep the report shorter than the source material it summarizes.

## Non-Goals

- Do not modify knowledge files, `CLAUDE.md`, or `.claude/rules/` directly.
- Do not quote secrets or credential-like values.
- Do not promote, extract, or rewrite rules inside this review step.
- Do not label one-off trivia as a promotion candidate.

## Output Format

1. REVIEW MODE

State whether the run was full, `--quick`, `--stale`, or `--candidates`.

2. KNOWLEDGE HEALTH

State file counts, total size, and overall health impression.

3. FINDINGS

List:
- promotion candidates
- stale entries
- consolidation opportunities
- conflicts

4. SAFETY NOTES

State any redactions or confidence limits.

5. RECOMMENDATIONS

State the next bounded action, such as `si-promote`, `si-extract`, cleanup, or
stop.
