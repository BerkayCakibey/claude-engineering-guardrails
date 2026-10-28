---
name: sast-jwt
description: >-
  Review JWT signing, validation, expiry, audience, issuer, and key-handling risks.
---

# Skill: sast-jwt

## Purpose
Review JWT signing, validation, expiry, audience, issuer, and key-handling risks.

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
- Map token creation, validation, refresh, revocation, key loading, and claim-to-authorization decisions.
- Confirm algorithm pinning, signature verification, issuer, audience, expiry, not-before, and key rotation behavior.
- Check role, tenant, and subject claims against server-side authorization state.
- Reject leads when claims are treated only as identity hints and every sensitive action rechecks server-side state.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [token source, validation path, and authorization decision]

## Findings Or Implementation
- [confirmed JWT findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
