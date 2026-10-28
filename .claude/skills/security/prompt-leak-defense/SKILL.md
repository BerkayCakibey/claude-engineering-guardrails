---
name: prompt-leak-defense
description: >-
  Review prompt extraction, system-prompt leakage, and AI startup data exposure risks.
---

# Skill: prompt-leak-defense

## Purpose
Review prompt extraction, system-prompt leakage, and AI startup data exposure risks. Treat this as a narrow pattern card: use it to sharpen one decision surface quickly, then hand back to the broader workflow.

## Use When
- The active question is primarily about: review prompt extraction, system-prompt leakage, and AI startup data exposure risks.
- A broader skill exists, but the current question is narrow enough for a fast focused review.
- You want a reusable checklist before implementation, review, or escalation continues.

## Do Not Use When
- The task needs an end-to-end workflow or multi-step implementation chain. Use `security-scan`.
- The main risk has shifted to an adjacent concern outside this card. Use `skill-security-auditor`.
- The user only wants generic best practices with no repo, product, or workflow context.

## Focus Checklist
1. Treat review prompt extraction, system-prompt leakage, and AI startup data exposure risks as a concrete exfiltration and trust-boundary problem, not generic awareness advice.
2. Map which prompts, logs, files, or startup surfaces could leak sensitive data.
3. Prefer mitigations that are enforceable in prompts, hooks, logs, or routing policy.
4. Separate confirmed exposure paths from hypothetical attacker stories.

## Evidence To Collect
- the prompt, file, or startup surface under review
- one confirmed or plausible leakage path
- the smallest mitigation and the check that proves it works

## Related Skills
- Primary broader workflow: `security-scan`
- Adjacent boundary: `skill-security-auditor`
- This card stays active only while its narrow scope remains smaller than those broader lanes.

## Group
Security And SAST

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
