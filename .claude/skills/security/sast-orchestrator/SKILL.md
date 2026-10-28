---
name: sast-orchestrator
description: >-
  Coordinate multi-phase SAST analysis from architecture mapping to specialist checks and final report.
---

# Skill: sast-orchestrator

## Purpose
Coordinate multi-phase SAST analysis from architecture mapping to specialist checks and final report.

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

## Multi-Phase SAST Flow
1. Map entry points, trust boundaries, data sinks, auth model, and validation evidence.
2. Route only mapped leads to specialist lanes such as IDOR, missing auth, SQLi, SSRF, RCE, XSS, JWT, GraphQL, file upload, path traversal, SSTI, XXE, and prompt leak defense.
3. Prove or reject each lead with source, sink, attacker control, guard analysis, impact, and remediation.
4. Compile a report that separates confirmed vulnerabilities from static pattern leads.
5. Self-check for secret redaction, severity ordering, and evidence quality.

## False-Positive Discipline
- Do not report a vulnerability only because a risky function appears.
- Record the guard that makes a lead non-exploitable.
- Keep framework defaults explicit; do not assume they are present.
- Prefer code evidence over generic OWASP language.

Reference workflow: `references/sast-triage-matrix.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [map scope, lanes selected, and proof standard]

## Findings Or Implementation
- [confirmed findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
