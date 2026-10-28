---
name: qa-only
description: >-
  Run browser-visible QA and produce an evidence-backed report without editing code.
---

# Skill: qa-only

## Purpose
Review behavior, UI, and visible regressions without drifting into implementation work.

## Use When
- The user wants a QA pass only.
- A deployed or local site needs verification before code changes are proposed.
- You need screenshots, repro steps, and severity calls rather than patches.

## Rules
1. Do not edit files under this skill unless the user explicitly changes scope.
2. Prefer browser evidence, screenshots, and exact repro steps.
3. Separate blockers from polish issues.
4. Call out missing states you could not verify directly.

## QA Focus
- broken or misleading UI states
- console errors and failed requests when visible
- responsive overflow or clipping
- journey blockers, auth problems, and dead ends
- copy clarity when it affects task completion

## Output Requirements
```markdown
## Scope
- [pages, devices, and flows checked]

## Findings
- Severity: HIGH | MEDIUM | LOW
- Issue: [concrete visible problem]
- Repro: [exact steps]

## Evidence
- [screenshots, URLs, browser notes]

## Unverified Areas
- [states not reached or not testable]
```

## Group
Product Design And QA
