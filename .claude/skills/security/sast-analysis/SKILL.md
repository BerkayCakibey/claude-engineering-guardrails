---
name: sast-analysis
description: >-
  Map architecture, entry points, data flows, and trust boundaries before vulnerability checks.
---

# Skill: sast-analysis

## Purpose
Map architecture, entry points, data flows, and trust boundaries before vulnerability checks.

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

## Analysis Map
- Entry points: routes, CLI commands, workers, jobs, webhooks, subscriptions, imports, uploads.
- Sources: request input, files, environment, database records, third-party callbacks, tokens.
- Sinks: auth decisions, SQL, filesystem, shell, HTTP clients, renderers, parsers, queues, email, payments.
- Guards: middleware, schema validation, allowlists, authorization checks, transactions, sandboxing, rate limits.
- Evidence: exact files, configs, tests, and assumptions needed to route specialist lanes.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [entry points, sources, sinks, and guards to map]

## Findings Or Implementation
- [trust-boundary map and recommended specialist lanes]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
