---
name: freeze-scope
description: >-
  Constrain edits to an approved path or component while debugging or doing focused repairs.
---

# Skill: freeze-scope

## Purpose
Constrain edits to an approved path or component while debugging or doing focused repairs. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: constrain edits to an approved path or component while debugging or doing focused repairs.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `spec-driven-workflow`.
- The main risk has shifted to an adjacent concern outside this card. Use `safety-guard`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Reduce constrain edits to an approved path or component while debugging or doing focused repairs to an explicit entry condition, exit condition, and owner.
2. Keep the plan small enough that another skill can execute it without reinterpretation.
3. Call out what is deliberately out of scope for this step.
4. Prefer irreversible-decision checkpoints over broad open-ended planning prose.

## Evidence To Collect
- approved scope, affected files, or affected workflow surface
- the step order or phase handoff notes
- the verification rule that marks the card complete

## Related Skills
- Primary broader workflow: `spec-driven-workflow`
- Adjacent boundary: `safety-guard`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Product Design And QA

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
