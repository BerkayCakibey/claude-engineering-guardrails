---
name: agent-harness-construction
description: >-
  Build agent harnesses with tool boundaries, context loading, memory, and verification loops.
---

# Skill: agent-harness-construction

## Purpose
Build agent harnesses with tool boundaries, context loading, memory, and verification loops. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: build agent harnesses with tool boundaries, context loading, memory, and verification loops.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `agent-workflow-designer`.
- The main risk has shifted to an adjacent concern outside this card. Use `harness-optimization`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Map the current repo surface for build agent harnesses with tool boundaries, context loading, memory, and verification loops before proposing a new abstraction or directory shape.
2. Name the boundary explicitly: inputs, outputs, ownership, and trust edges.
3. Keep the first version smaller than the full workflow you could imagine building.
4. Define the verification path before adding automation or new runtime surfaces.

## Evidence To Collect
- current files, commands, or interfaces that establish the baseline
- one proposed boundary diagram, manifest sketch, or routing note
- the smallest verification or smoke-test path that proves the design

## Related Skills
- Primary broader workflow: `agent-workflow-designer`
- Adjacent boundary: `harness-optimization`
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
