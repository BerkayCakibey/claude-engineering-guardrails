---
name: sast-fileupload
description: >-
  Review file upload, parsing, storage, content-type, malware, and path risks.
---

# Skill: sast-fileupload

## Purpose
Review file upload, parsing, storage, content-type, malware, and path risks.

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
- Map upload endpoints, parsers, archive handlers, media processors, storage buckets, and download paths.
- Confirm extension, MIME, magic bytes, size, count, malware, image re-encoding, and executable-content controls.
- Check storage isolation, public URL exposure, path selection, and post-upload processing privileges.
- Reject leads when files are stored inertly, never executed/rendered unsafely, and size/type limits are enforced.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [upload source, parser/storage sink, and validation guards]

## Findings Or Implementation
- [confirmed file-upload findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
