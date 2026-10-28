---
name: sast-rce
description: >-
  Review subprocess, template, eval, deserialization, plugin, and command execution surfaces.
---

# Skill: sast-rce

## Purpose
Review subprocess, template, eval, deserialization, plugin, and command execution surfaces.

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
- Map shell calls, eval/exec, dynamic imports, plugin loading, deserialization, template execution, and sandbox escapes.
- Confirm whether untrusted input reaches command, argument, environment, working directory, code string, or plugin path.
- Check allowlists, argument arrays, sandbox isolation, path guards, and execution user permissions.
- Reject leads when input is data-only and cannot affect executable structure or loaded code.

Reference: `../sast-orchestrator/references/specialist-lane-playbooks.md`.

## Group
Security And SAST

## Minimal Output
```markdown
## Plan
- [execution source, sink, and sandbox/allowlist guard]

## Findings Or Implementation
- [confirmed RCE findings and rejected leads]

## Evidence
- [checks, files, commands, or artifacts]

## Risks
- [remaining uncertainty or follow-up]
```
