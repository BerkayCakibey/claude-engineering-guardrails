---
name: sast-report
description: >-
  Write evidence-based SAST reports with severity, exploitability, and remediation detail.
---

# Skill: sast-report

## Purpose
Write evidence-based SAST reports with severity, exploitability, and remediation detail.

## Use When
- The user asks for work in this capability area.
- Existing claude-engineering-guardrails skills do not provide enough domain-specific guidance.
- A claude-engineering-guardrails workflow needs explicit, repeatable gates instead of ad hoc prompting.

## Operating Contract
1. Identify the repository or product context before recommending changes.
2. Prefer existing local tools, scripts, settings, and validation style.
3. Keep trust boundaries explicit: files, credentials, external services, network calls, databases, and user data.
4. Produce evidence: commands, inspected files, screenshots, reports, tests, or clearly labeled assumptions.
5. Avoid broad automation until the user has approved the affected surface.

## Report Contract
- Lead with confirmed Critical and High findings; keep pattern leads separate.
- Each finding must include source, sink, missing guard, exploit path, impact, and minimal fix.
- Redact secret values and avoid exploit payloads that enable misuse beyond proof.
- Include rejected leads when they are likely to be rediscovered later.
- Downgrade confidence when evidence is incomplete.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [report scope, severity model, and evidence standard]

## Findings Or Implementation
- [confirmed findings, rejected leads, and remediation]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
