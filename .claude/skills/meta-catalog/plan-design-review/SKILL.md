---
name: plan-design-review
description: >-
  Review design plans for taste, layout, accessibility, AI slop, and interaction quality.
---

# Skill: plan-design-review

## Purpose
Review design plans for taste, layout, accessibility, AI slop, and interaction quality.

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
- information hierarchy and primary user path
- layout stability across mobile and desktop
- accessibility, contrast, keyboard flow, and readable copy
- palette, typography, spacing, and component consistency
- visual anti-patterns, generic AI slop, and decorative clutter
- browser evidence when UI already exists

Reference workflow: `../office-hours/references/review-board-routing.md`.

## Group
Product Design And QA

## Minimal Output
```markdown
## Plan
- [screens, states, and visual evidence needed]

## Findings Or Implementation
- [design blockers, polish issues, and evidence]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
