---
name: click-path-audit
description: >-
  Audit critical user journeys by walking real flows, capturing friction, and separating blockers from polish.
---

# Skill: click-path-audit

## Purpose
Audit user journeys by following the real click path and recording where momentum breaks.

## Use When
- The user wants journey QA rather than component-only review.
- A signup, onboarding, checkout, or dashboard path needs browser-visible validation.
- You need evidence of friction, dead ends, broken states, or misleading transitions.

## Workflow
1. Define the journey start, success condition, and stop condition.
2. List the pages, modals, form states, and redirects expected on the path.
3. Walk the flow in the browser, capturing screenshots and unexpected branches.
4. Separate:
   - hard blockers
   - misleading or high-friction moments
   - polish-only issues
5. Call out whether the breakage is content, state management, navigation, auth, or browser-specific.

## Review Focus
- first-run clarity and CTA discoverability
- navigation continuity between steps
- validation, error recovery, and retry path quality
- spinner, empty, and redirect states
- mobile/desktop divergence when the path matters on both

## Evidence Contract
- Prefer `browser-audit` when the path is browser-visible.
- Record the exact step where the journey failed or degraded.
- Include enough path detail that another person can reproduce the issue.

## Output Requirements
```markdown
## Journey
- Start: [entry point]
- Success state: [expected completion]

## Findings
- Step: [where the issue happened]
- Severity: HIGH | MEDIUM | LOW
- Friction: [blocker, detour, confusion, broken state]
- Fix direction: [smallest useful change]

## Evidence
- [screenshots, URLs, states, browser notes]

## Follow-up
- [open questions or next verification]
```

## Group
Product Design And QA
