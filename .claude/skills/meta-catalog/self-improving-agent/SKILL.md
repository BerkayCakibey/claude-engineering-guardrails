---
name: "self-improving-agent"
description: "Curate the project's optional local knowledge files into durable project knowledge. Analyze knowledge entries for patterns, promote proven learnings to CLAUDE.md and .claude/rules/, extract recurring solutions into reusable skills. Use when: reviewing what Claude has learned, graduating a pattern from notes to enforced rules, turning a debugging solution into a skill, or checking knowledge health and capacity."
---

# Skill: self-improving-agent

## Purpose
Curate project knowledge into durable, reusable guidance without turning
temporary notes into permanent rules too early. Use this skill to orchestrate
status checks, knowledge review, promotion, extraction, and explicit memory
writes across the self-improvement surface.

## Trigger Conditions

Use this skill when:
- the task spans more than one self-improvement command, such as reviewing
  knowledge health and then promoting or extracting patterns
- the correct next step between `/si-status`, `/si-review`, `/si-promote`,
  `/si-extract`, and `/si-remember` is not yet clear
- the user wants a broader knowledge-governance pass instead of one bounded
  command
- pattern promotion may change `CLAUDE.md`, `.claude/rules/`, or reusable
  skill boundaries

Use the narrower `si-*` skill directly when the task already fits one command.

## Input Boundary

The user may provide:
- a project or repository path
- a question about knowledge health, promotion, extraction, or memory capture
- a target pattern, rule candidate, or knowledge entry
- an explicit request to review, promote, remember, or extract

Inspect only the surfaces needed for the chosen route:
- `.claude/knowledge/` when the optional local knowledge store exists
- project `CLAUDE.md`
- `.claude/rules/`
- supporting references and templates in this directory

## Step Order (Mandatory)

1. Identify whether the task is status, review, promotion, extraction,
   remember, or a multi-step combination.
2. Inspect the relevant knowledge surface before recommending changes. If the
   optional local knowledge store is absent, report that and avoid assuming one
   should exist.
3. Route to the narrowest fitting sub-skill when one command can complete the
   task:
   - `si-status`
   - `si-review`
   - `si-promote`
   - `si-extract`
   - `si-remember`
4. Stay in this broader skill only when orchestration across multiple
   sub-skills is necessary.
5. Apply redaction rules before reporting on memory contents or promotion
   candidates.
6. Require explicit confirmation before removing or rewriting user-authored
   knowledge entries or rule content.
7. Summarize what was reviewed, what changed, and what should happen next.

## Command Routes

- `/si-status`
  - Use for a bounded health dashboard, capacity check, or quick stale-surface
    overview.
- `/si-review`
  - Use for promotion candidates, stale entries, consolidation opportunities,
    and conflicts.
- `/si-promote`
  - Use when a proven pattern should graduate into `CLAUDE.md` or
    `.claude/rules/`.
- `/si-extract`
  - Use when a recurring pattern should become a standalone reusable skill.
- `/si-remember`
  - Use when an important discovery should be stored in project knowledge now.

## Support Surface

- References:
  - `reference/memory-architecture.md`
  - `reference/promotion-rules.md`
  - `reference/rules-directory-patterns.md`
- Templates:
  - `templates/rule-template.md`
  - `templates/skill-template.md`
- Related agents:
  - `memory-analyst` for read-only knowledge audits
  - `skill-extractor` for bounded skill package generation

## Evidence Expectations

- State which knowledge surfaces were inspected.
- State whether the task stayed in the parent workflow or routed to a narrower
  `si-*` skill.
- Distinguish verified entries from inferred or proposed rules.
- When mutation is proposed, state the target file and confirmation boundary.

## Non-Goals

- Do not quote secrets, tokens, passwords, keys, or connection strings from
  knowledge files.
- Do not promote one-off debugging notes into permanent rules without evidence
  of recurrence.
- Do not overwrite `CLAUDE.md`, `.claude/rules/`, or knowledge files without a
  clear target and explicit user approval where removal is involved.
- Do not turn this parent skill into a duplicate of the narrower `si-*`
  command workflows.

## Output Format

1. ROUTE DECISION

State whether the task should use `si-status`, `si-review`, `si-promote`,
`si-extract`, `si-remember`, or a multi-step parent workflow.

2. SURFACES INSPECTED

List the knowledge, rule, or template files reviewed.

3. FINDINGS OR CHANGES

State the health findings, promotion candidates, mutations performed, or
extraction result.

4. SAFETY NOTES

State any redactions, confirmation requirements, or unresolved ambiguity.

5. NEXT STEP

State the next bounded command, approval point, or stop condition.
