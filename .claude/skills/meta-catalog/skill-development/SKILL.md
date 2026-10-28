---
name: skill-development
description: >-
  Create progressive-disclosure skills with references, scripts, and trigger-focused descriptions.
---

# Skill: skill-development

## Purpose
Create progressive-disclosure skills with references, scripts, and trigger-focused descriptions. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: create progressive-disclosure skills with references, scripts, and trigger-focused descriptions.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `skill-creator`.
- The main risk has shifted to an adjacent concern outside this card. Use `skill-tester`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Map the current repo surface for create progressive-disclosure skills with references, scripts, and trigger-focused descriptions before proposing a new abstraction or directory shape.
2. Name the boundary explicitly: inputs, outputs, ownership, and trust edges.
3. Keep the first version smaller than the full workflow you could imagine building.
4. Define the verification path before adding automation or new runtime surfaces.

## Evidence To Collect
- current files, commands, or interfaces that establish the baseline
- one proposed boundary diagram, manifest sketch, or routing note
- the smallest verification or smoke-test path that proves the design

## Related Skills
- Primary broader workflow: `skill-creator`
- Adjacent boundary: `skill-tester`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Harness And Agent Mechanics

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
