---
name: sast-xxe
description: >-
  Review XML parsing, entity expansion, document conversion, and parser hardening.
---

# Skill: sast-xxe

## Purpose
Review XML parsing, entity expansion, document conversion, and parser hardening.

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
- Map XML, SVG, SOAP, SAML, Office document, PDF conversion, and import parsers.
- Confirm external entities, DTDs, network fetches, entity expansion, and file access are disabled.
- Check parser options in the actual library and version used by the repo.
- Reject leads when the parser cannot resolve entities and untrusted XML is not accepted.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [XML source, parser sink, and entity/network guard]

## Findings Or Implementation
- [confirmed XXE findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
