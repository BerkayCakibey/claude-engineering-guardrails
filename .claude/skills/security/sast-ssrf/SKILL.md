---
name: sast-ssrf
description: >-
  Review server-side fetches, webhooks, metadata services, redirects, and URL allowlists.
---

# Skill: sast-ssrf

## Purpose
Review server-side fetches, webhooks, metadata services, redirects, and URL allowlists.

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

## Specialist Lane
- Map server-side HTTP clients, webhook fetchers, importers, previewers, metadata calls, and redirects.
- Confirm URL canonicalization, scheme allowlist, DNS/IP checks, redirect policy, timeout, and response-size limits.
- Treat cloud metadata, localhost, private IP ranges, and internal service discovery as sensitive sinks.
- Reject leads when the URL is selected from a fixed server-side allowlist and redirects cannot escape it.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [URL source, fetch sink, and network guard]

## Findings Or Implementation
- [confirmed SSRF findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
