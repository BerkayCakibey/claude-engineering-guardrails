---
name: "si-promote"
description: "Graduate a proven pattern from optional local knowledge files (`.claude/knowledge/`) to CLAUDE.md or .claude/rules/ for permanent enforcement. Use when: a pattern has proven itself across sessions and should become an enforced rule."
command: /si-promote
---

# Skill: si-promote

## Purpose
Promote a proven pattern from optional local project knowledge into `CLAUDE.md` or
`.claude/rules/` so it becomes an enforced rule instead of a background note.
This is the command-backed mutation workflow for rule graduation.

## Command Alias

Primary command:

```text
/si-promote <pattern description> [--target claude.md|rules/<name>.md]
```

Prefer the command alias when the user already wants promotion. Use
`self-improving-agent` first when the task still needs review or route
selection.

## Trigger Conditions

Use this skill when:
- a pattern has recurred enough to justify permanent enforcement
- the user wants a knowledge entry moved into project rules
- a candidate from `si-review` is ready for promotion

## Input Boundary

The user may provide:
- a pattern description
- an explicit target such as `claude.md` or `rules/<name>.md`
- a referenced knowledge entry

Inspect:
- the relevant `.claude/knowledge/*.md` entries when the optional local
  knowledge store exists
- project `CLAUDE.md`
- `.claude/rules/`

## Step Order (Mandatory)

1. Identify the exact pattern to promote and confirm it is specific enough to
   locate.
2. Find the relevant knowledge entry or entries in optional local
   `.claude/knowledge/`.
3. Check whether the pattern is already covered by `CLAUDE.md` or an existing
   rule.
4. Choose the correct destination:
   - project-wide guidance -> `CLAUDE.md`
   - scoped behavior -> `.claude/rules/<topic>.md`
   - global cross-project preference -> `~/.claude/CLAUDE.md` only if the user
     explicitly asks for that surface
5. Distill the note into a concise, imperative rule.
6. Write the rule to the target file.
7. Ask for explicit confirmation before removing the original knowledge entry.
8. Report what changed and what cleanup remains.

## Evidence Expectations

- State the source knowledge entry or entries used for promotion.
- State why the pattern is durable enough to promote.
- State why the selected target is the correct scope.
- Show the distilled rule text without leaking secrets.

## Non-Goals

- Do not promote one-off debugging notes or unstable migration guidance.
- Do not remove knowledge entries without explicit confirmation.
- Do not promote credential-bearing entries; flag them for redaction instead.
- Do not rewrite unrelated rules while promoting one pattern.

## Output Format

1. PROMOTION DECISION

State the pattern, its source, and whether promotion is justified.

2. TARGET

State the selected destination and why that scope fits.

3. DISTILLED RULE

Show the final instruction text written or proposed.

4. CLEANUP STATUS

State whether the original knowledge entry was removed, left in place pending
confirmation, or flagged for redaction.

5. NEXT STEP

State any follow-up such as `si-review`, `si-extract`, or stop.
