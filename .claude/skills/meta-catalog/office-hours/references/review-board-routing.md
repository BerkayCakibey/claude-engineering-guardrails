# Review Board Routing

Use this reference for gstack-style product and execution review without
importing an external runtime.

## Route By Question

| Question | Use |
|---|---|
| Is this worth building? | `office-hours`, then `plan-ceo-review` |
| Is the plan technically coherent? | `plan-eng-review` |
| Will the UI feel credible and usable? | `plan-design-review` |
| Can a developer adopt or maintain it easily? | `plan-devex-review` |
| Does the existing UI work in browsers? | `qa`, `qa-only`, `browser-audit`, `click-path-audit` |
| Is the rollout safe? | `canary-watch`, `benchmark`, `safety-guard`, `freeze-scope` |
| Is a second model/reviewer useful? | `codex-second-opinion` |

## Office-Hours Gate

Ask forcing questions before planning:

- Who is the exact user?
- What pain happens if this is not built?
- What is the smallest wedge?
- What is intentionally out of scope?
- What would make the work obviously fail?
- What evidence would change the decision?

## Review Order

1. CEO review: value, wedge, scope, tradeoff.
2. Engineering review: architecture, data flow, tests, failure modes.
3. Design review: information hierarchy, layout stability, accessibility, taste.
4. DX review: setup, commands, docs, time-to-first-success.
5. QA/canary review: browser evidence, telemetry, rollback, release guard.

Skip review modes that do not match the task. Do not perform a ceremony when a
small code fix only needs implementation and self-check.

## Output Shape

```markdown
## Decision
- [build / revise / stop]

## Review Findings
- CEO:
- Engineering:
- Design:
- DX:
- QA/Canary:

## Required Changes
- [ordered by risk]

## Evidence
- [files, screenshots, commands, reports, assumptions]
```
