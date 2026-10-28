---
name: canary-watch
description: >-
  Watch post-deploy pages, console errors, health checks, and regressions during a canary or soft rollout.
---

# Skill: canary-watch

## Purpose
Monitor the first visible minutes of a rollout so regressions are caught before they become normal traffic.

## Use When
- A new deployment needs post-release observation.
- A user wants a canary checklist or soft-launch QA pass.
- You need to watch for console noise, route breakage, and key journey regressions.

## Monitoring Focus
1. Can the page load and render cleanly?
2. Did the primary CTA and critical journeys survive the rollout?
3. Did new console or network errors appear?
4. Did performance or layout regress on mobile or desktop?
5. Is there a clear rollback or escalation trigger if degradation appears?

## Output Requirements
```markdown
## Canary Scope
- [deployment, routes, devices, and observation window]

## Signals
- Healthy: [what stayed normal]
- Regressed: [what degraded]

## Evidence
- [screenshots, console notes, URLs, health checks]

## Decision
- [continue, hold, rollback, or investigate]
```

## Group
Product Design And QA
