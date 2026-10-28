---
name: plan-eng-review
description: >-
  Review implementation plans for architecture, data flow, tests, and failure modes.
---

# Skill: plan-eng-review

## Purpose
Review implementation plans for architecture, data flow, tests, and failure modes.

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

## Review Focus
- architecture boundaries and ownership
- data flow, persistence, queues, caches, and external calls
- failure modes, retries, idempotency, rollback, and observability
- test plan, fixtures, smoke checks, and false-green risks
- migration and deploy sequencing
- security boundaries that need a specialist SAST lane

Reference workflow: `../office-hours/references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [architecture surface and risk focus]

## Findings Or Implementation
- [blocking issues, non-blocking risks, and required tests]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
