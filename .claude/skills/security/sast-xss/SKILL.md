---
name: sast-xss
description: >-
  Review client/server rendering, sanitization, markdown, rich text, and CSP coverage.
---

# Skill: sast-xss

## Purpose
Review client/server rendering, sanitization, markdown, rich text, and CSP coverage.

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
- Map rendered user content across HTML, attributes, URLs, scripts, markdown, rich text, and server templates.
- Confirm whether escaping or sanitization matches the output context.
- Check stored, reflected, DOM, markdown, and rich-text editor paths separately.
- Reject leads when the framework auto-escapes the exact sink and no unsafe bypass is present.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [content source, render sink, and context-specific guard]

## Findings Or Implementation
- [confirmed XSS findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
