---
name: git-workflow
description: >-
  Prepare safe local git workflows, commits, diffs, and handoffs without pushing by default.
---

# Skill: git-workflow

## Purpose
Prepare safe local git workflows, commits, diffs, and handoffs without pushing by default. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: prepare safe local git workflows, commits, diffs, and handoffs without pushing by default.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `git-pr-packager`.
- The main risk has shifted to an adjacent concern outside this card. Use `safety-guard`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Reduce prepare safe local git workflows, commits, diffs, and handoffs without pushing by default to an explicit entry condition, exit condition, and owner.
2. Keep the plan small enough that another skill can execute it without reinterpretation.
3. Call out what is deliberately out of scope for this step.
4. Prefer irreversible-decision checkpoints over broad open-ended planning prose.

## Evidence To Collect
- approved scope, affected files, or affected workflow surface
- the step order or phase handoff notes
- the verification rule that marks the card complete

## Related Skills
- Primary broader workflow: `git-pr-packager`
- Adjacent boundary: `safety-guard`
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
