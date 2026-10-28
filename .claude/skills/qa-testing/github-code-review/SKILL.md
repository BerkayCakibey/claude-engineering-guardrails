---
name: github-code-review
description: >-
  Review GitHub-oriented changes for bugs, tests, security, and regression risk without issue-template machinery.
---

# Skill: github-code-review

## Purpose
Review GitHub-oriented changes for bugs, tests, security, and regression risk without issue-template machinery. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: review GitHub-oriented changes for bugs, tests, security, and regression risk without issue-template machinery.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `code-reviewer`.
- The main risk has shifted to an adjacent concern outside this card. Use `search-first`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Use review GitHub-oriented changes for bugs, tests, security, and regression risk without issue-template machinery to challenge the current path with concrete evidence, not generic second-guessing.
2. Call out where the broader workflow is already sufficient and where this card adds distinct value.
3. Prefer contradictions, missing evidence, and blind spots over style opinions.
4. Return a bounded next move instead of an open-ended debate.

## Evidence To Collect
- current plan, diff, or review target
- one concrete disagreement or missing proof
- the specific next step that resolves the disagreement

## Related Skills
- Primary broader workflow: `code-reviewer`
- Adjacent boundary: `search-first`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Engineering Workflow

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
