---
name: sast-sqli
description: >-
  Review SQL construction, ORM escape hatches, filters, ordering, and raw query surfaces.
---

# Skill: sast-sqli

## Purpose
Review SQL construction, ORM escape hatches, filters, ordering, and raw query surfaces.

## Use When
- The user asks for work in this capability area.
- Existing claude-engineering-guardrails skills do not provide enough domain-specific guidance.
- A claude-engineering-guardrails workflow needs explicit, repeatable gates instead of ad hoc prompting.

## Operating Contract
1. Identify the repository or product context before recommending changes.
2. Prefer existing local tools, scripts, settings, and validation style.
3. Keep trust boundaries explicit: files, credentials, external services, network calls, databases, and user data.
4. Produce evidence: commands, inspected files, screenshots, reports, tests, or clearly labeled assumptions.
5. Avoid broad automation until the user has approved the affected surface.

## Specialist Lane
- Map raw SQL, query builders, ORM escape hatches, dynamic filters, sorting, and search clauses.
- Confirm whether untrusted input changes query structure or only parameter values.
- Check identifier injection separately from value injection; placeholders rarely protect table, column, or order tokens.
- Reject leads when allowlists or typed query APIs constrain the structure before execution.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [query source, construction path, and execution sink]

## Findings Or Implementation
- [confirmed SQLi findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
