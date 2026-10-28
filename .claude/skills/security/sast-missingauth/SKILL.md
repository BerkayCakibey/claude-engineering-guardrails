---
name: sast-missingauth
description: >-
  Find unauthenticated or under-authorized routes, handlers, jobs, and resources.
---

# Skill: sast-missingauth

## Purpose
Find unauthenticated or under-authorized routes, handlers, jobs, and resources.

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
- Inventory routes, handlers, jobs, webhooks, admin actions, and resource endpoints.
- Confirm identity, role, tenant, and ownership checks happen before sensitive work.
- Compare protected and unprotected route groups for middleware drift.
- Reject leads when the route is intentionally public and reaches no sensitive sink.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [endpoint/action, required identity, and guard location]

## Findings Or Implementation
- [confirmed missing-auth findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
