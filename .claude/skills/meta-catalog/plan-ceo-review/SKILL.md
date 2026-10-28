---
name: plan-ceo-review
description: >-
  Review product plans for scope, wedge, positioning, and strategic tradeoffs.
---

# Skill: plan-ceo-review

## Purpose
Review product plans for scope, wedge, positioning, and strategic tradeoffs.

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
- exact user and urgent pain
- smallest credible wedge
- scope that must be cut
- positioning and differentiation
- success evidence and kill criteria
- whether the plan is worth engineering effort now

Reference workflow: `../office-hours/references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [product context and decision criteria]

## Findings Or Implementation
- [build/revise/stop recommendation and tradeoffs]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
