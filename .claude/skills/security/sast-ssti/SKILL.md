---
name: sast-ssti
description: >-
  Review server-side template rendering, expression evaluation, and sandbox escapes.
---

# Skill: sast-ssti

## Purpose
Review server-side template rendering, expression evaluation, and sandbox escapes.

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
- Map template rendering APIs, custom template strings, CMS/email templates, previews, and expression evaluators.
- Confirm user input becomes data variables, not template source or executable expressions.
- Check sandbox settings, helper exposure, filesystem/network access, and template inheritance.
- Reject leads when templates are static and user content is only escaped data.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [template source, render sink, and sandbox guard]

## Findings Or Implementation
- [confirmed SSTI findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
