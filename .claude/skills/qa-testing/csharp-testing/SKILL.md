---
name: csharp-testing
description: >-
  Plan C# unit, integration, fixture, mock, and test container checks.
---

# Skill: csharp-testing

## Purpose
Plan C# unit, integration, fixture, mock, and test container checks. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: plan C# unit, integration, fixture, mock, and test container checks.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `test-strategy-planner`.
- The main risk has shifted to an adjacent concern outside this card. Use `repo-navigator`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Account for xUnit/NUnit/MSTest conventions, async deadlock risk, DI test hosts, and Testcontainers only where the seam is real.
2. Separate unit, integration, heavier environment, and regression checks.
3. Make false-green and flaky-path risk explicit before adding fixtures.
4. Escalate to `test-strategy-planner` if the task becomes a full implementation or cross-language test strategy exercise.

## Evidence To Collect
- test project entry point, host setup, and the one async/DI path the suite must verify
- exact commands or harnesses that would run the tests
- the one failure mode the proposed tests must catch

## Related Skills
- Primary broader workflow: `test-strategy-planner`
- Adjacent boundary: `repo-navigator`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Language And Framework

## Output Contract
```markdown
## Decision
- [recommended pattern, constraint, or next move]

## Risks
- [main failure or tradeoff]

## Evidence
- [files, commands, examples, metrics, or assumptions]

## Next Step
- [implement, escalate, or stop]
```
