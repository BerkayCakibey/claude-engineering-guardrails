---
name: qa
description: >-
  Run browser-visible QA, fix findings when authorized, and verify regressions.
---

# Skill: qa

## Purpose
Run browser-visible QA, fix findings when authorized, and verify regressions.

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

## QA Route
- Use `qa-only` for read-only browser-visible issue discovery.
- Use `browser-audit` for deterministic screenshots, console/network failures, overflow, broken images, and responsive evidence.
- Use `click-path-audit` when the user journey matters more than a static page.
- Use `benchmark` and `canary-watch` only when performance or rollout safety is in scope.
- Use `safety-guard` and `freeze-scope` before high-risk changes or deployment-adjacent work.

Reference workflow: `../office-hours/references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [target pages, viewport/device set, and fix authorization]

## Findings Or Implementation
- [browser-visible findings and fixes]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
