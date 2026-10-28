---
name: sast-businesslogic
description: >-
  Find business-logic abuse paths that static pattern checks miss.
---

# Skill: sast-businesslogic

## Purpose
Find business-logic abuse paths that static pattern checks miss.

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
- Map the intended state machine, limits, approvals, quotas, payments, ownership, and replay rules.
- Check reorder, skip, replay, race, duplicate, refund, coupon, invite, and privilege-escalation paths.
- Confirm invariants are enforced server-side and inside transactions where needed.
- Reject leads when business limits are advisory only and no security or integrity impact exists.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [business invariant, state transition, and abuse path]

## Findings Or Implementation
- [confirmed business-logic findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
