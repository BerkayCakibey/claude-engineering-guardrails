---
name: sast-graphql
description: >-
  Review GraphQL schemas, resolvers, auth, batching, depth, and data exposure risks.
---

# Skill: sast-graphql

## Purpose
Review GraphQL schemas, resolvers, auth, batching, depth, and data exposure risks.

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
- Map schema, resolvers, loaders, mutations, subscriptions, introspection, batching, and federation boundaries.
- Confirm authorization is enforced per resolver and per object, not only at the top-level operation.
- Check depth, complexity, pagination, batching abuse, overfetching, and sensitive field exposure.
- Reject leads when schema exposure is intended and sensitive fields still enforce resolver-level guards.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [operation/resolver, data sink, and auth/complexity guard]

## Findings Or Implementation
- [confirmed GraphQL findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
