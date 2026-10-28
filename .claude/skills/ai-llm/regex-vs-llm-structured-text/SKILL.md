---
name: regex-vs-llm-structured-text
description: >-
  Choose regex, parsers, schemas, or LLM extraction for structured text tasks.
---

# Skill: regex-vs-llm-structured-text

## Purpose
Choose regex, parsers, schemas, or LLM extraction for structured text tasks. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: choose regex, parsers, schemas, or LLM extraction for structured text tasks.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `search-first`.
- The main risk has shifted to an adjacent concern outside this card. Use `mcp-builder`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Reduce choose regex, parsers, schemas, or LLM extraction for structured text tasks to the decision criteria that actually matter: structure, variability, cost, and failure handling.
2. Prefer the cheapest deterministic mechanism that still satisfies the task.
3. Call out where regex, parsers, schemas, or LLM extraction will fail first.
4. Do not recommend an LLM path only because it feels flexible.

## Evidence To Collect
- sample input shape and expected output shape
- one recommended mechanism and one rejected alternative
- the failure mode that would trigger escalation to a different approach

## Related Skills
- Primary broader workflow: `search-first`
- Adjacent boundary: `mcp-builder`
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
