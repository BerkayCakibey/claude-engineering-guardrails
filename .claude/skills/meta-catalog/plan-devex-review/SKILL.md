---
name: plan-devex-review
description: >-
  Review developer-experience plans for onboarding friction, time-to-hello-world, and docs flow.
---

# Skill: plan-devex-review

## Purpose
Review developer-experience plans for onboarding friction, time-to-hello-world, and docs flow.

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
- time-to-first-success and setup friction
- required tools, env vars, local services, and platform assumptions
- command naming, discoverability, and failure messages
- docs path from first run to common maintenance task
- test and validation commands a maintainer can actually run
- hidden dependencies, generated files, and unsafe defaults

Reference workflow: `../office-hours/references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [developer journey and setup assumptions]

## Findings Or Implementation
- [friction points and required docs/command fixes]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
