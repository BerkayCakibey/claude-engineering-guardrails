---
name: sast-idor
description: >-
  Review object-level authorization and insecure direct object reference risks.
---

# Skill: sast-idor

## Purpose
Review object-level authorization and insecure direct object reference risks.

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
- Map object identifiers from route, request body, query string, JWT/session, and database lookup.
- Confirm the ownership or tenant check is enforced on the object being read, changed, or deleted.
- Reject leads when the lookup is scoped by principal before the object is returned.
- Treat admin/service-token paths separately and prove the role boundary.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [object source, sink, and ownership guard to inspect]

## Findings Or Implementation
- [confirmed IDOR findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
