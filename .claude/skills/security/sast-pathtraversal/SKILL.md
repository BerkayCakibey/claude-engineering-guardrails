---
name: sast-pathtraversal
description: >-
  Review filesystem paths, archive extraction, uploads, downloads, and canonicalization.
---

# Skill: sast-pathtraversal

## Purpose
Review filesystem paths, archive extraction, uploads, downloads, and canonicalization.

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
- Map file reads, writes, deletes, archive extraction, downloads, uploads, object keys, and temp paths.
- Confirm canonicalization happens before access and that resolved paths stay inside the intended root.
- Check symlinks, encoded separators, dot segments, Windows paths, archive entries, and object-key prefixes.
- Reject leads when the path is server-generated or constrained by an allowlist before filesystem/object access.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [path source, filesystem/object sink, and root guard]

## Findings Or Implementation
- [confirmed path-traversal findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
