---
name: claude-code-concepts
description: >-
  Explain and apply Claude Code concepts: skills, agents, commands, hooks, settings, memory, MCP, and plugins.
---

# Skill: claude-code-concepts

## Purpose
Explain and apply Claude Code concepts: skills, agents, commands, hooks, settings, memory, MCP, and plugins. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: explain and apply Claude Code concepts: skills, agents, commands, hooks, settings, memory, MCP, and plugins.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `selective-install`.
- The main risk has shifted to an adjacent concern outside this card. Use `task-dispatcher`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Explain explain and apply Claude Code concepts: skills, agents, commands, hooks, settings, memory, MCP, and plugins using the current repo surfaces, not abstract platform lore.
2. Anchor every concept to a file, hook, command, or workflow in this depot.
3. Prefer distinctions and boundaries over encyclopedic coverage.
4. Escalate to `selective-install` when the user needs action, installation, or routing instead of explanation.

## Evidence To Collect
- the files or components used as examples
- one boundary statement clarifying what this concept does not do
- the next operational skill the user should invoke after the explanation

## Related Skills
- Primary broader workflow: `selective-install`
- Adjacent boundary: `task-dispatcher`
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
