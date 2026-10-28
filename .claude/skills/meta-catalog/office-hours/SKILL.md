---
name: office-hours
description: >-
  Interrogate product ideas with founder-style forcing questions before planning a build.
---

# Skill: office-hours

## Purpose
Interrogate product ideas with founder-style forcing questions before planning a build.

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

## Review Board Entry
Start with forcing questions, then route only the needed review modes:

- `plan-ceo-review` for value, wedge, scope, and positioning.
- `plan-eng-review` for architecture, data flow, tests, and failure modes.
- `plan-design-review` for visual hierarchy, accessibility, interaction quality, and AI-slop checks.
- `plan-devex-review` for setup, docs, commands, onboarding, and maintenance friction.
- `qa`, `browser-audit`, `benchmark`, `canary-watch`, `safety-guard`, and `freeze-scope` for browser evidence and rollout safety.

Reference workflow: `references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [forcing questions and selected review modes]

## Findings Or Implementation
- [decision, required changes, and review findings]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
