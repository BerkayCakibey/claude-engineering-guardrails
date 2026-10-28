---
name: "si-remember"
description: "Explicitly save important knowledge to the project's knowledge files with context. Use when: a discovery is too important to rely on auto-capture, or you want to ensure Claude remembers something specific."
command: /si-remember
---

# Skill: si-remember

## Purpose
Save an important project-specific fact or pattern into optional local
`.claude/knowledge/` when it should survive the current session but is not yet
ready to become a rule. This is the command-backed write workflow for explicit
knowledge capture.

## Command Alias

Primary command:

```text
/si-remember <what to remember>
```

Prefer the command alias when the user explicitly wants a discovery saved now.
Use `si-promote` instead when the content is already a stable enforced rule.

## Trigger Conditions

Use this skill when:
- a discovery is too important to leave in transient conversation state
- the user explicitly wants Claude to remember a project-specific fact
- the note belongs in project knowledge but not yet in `CLAUDE.md`

## Input Boundary

The user may provide:
- the fact or pattern to save
- optional context explaining why it matters

Inspect:
- `.claude/knowledge/` when it exists, or create that optional local store only
  when the user wants persistent project memory
- similar existing entries when duplicate checking is needed

## Step Order (Mandatory)

1. Parse the fact, why it matters, and whether it is project-specific.
2. Check for a nearby duplicate or conflicting knowledge entry.
3. If a similar entry exists, decide whether to update or append.
4. Write the note into the most appropriate knowledge file, keeping it concise.
5. If the note sounds like a durable rule, recommend `si-promote` instead of
   silently storing it as knowledge.
6. Warn if the knowledge surface is getting large enough to justify
   `si-review`.
7. Confirm the saved location and entry summary.

## Evidence Expectations

- State which knowledge file was created or updated.
- State whether a duplicate check was performed and what it found.
- State why the note stays in project knowledge instead of being promoted.

## Non-Goals

- Do not store credentials, tokens, API keys, or other secrets.
- Do not use this workflow for temporary conversational context.
- Do not silently convert a knowledge write into a rule promotion.
- Do not write cross-project preferences into project knowledge.

## Output Format

1. MEMORY DECISION

State what is being remembered and why it belongs in project knowledge.

2. TARGET FILE

State which knowledge file was created or updated.

3. DUPLICATE CHECK

State whether a similar entry already existed.

4. PROMOTION NOTE

State whether the entry should stay as knowledge or be promoted later.

5. NEXT STEP

State whether to continue, run `si-review`, use `si-promote`, or stop.
