---
name: "runbook-generator"
description: "Generates operational runbooks from incident patterns and system configurations"
---

# Skill: runbook-generator

## Purpose

Generate a runbook skeleton for a service, then shape it into an operationally
useful document with service-specific commands, checks, rollback guidance, and
ownership. This skill is an automation workbench, not a generic runbook essay.

## When To Use

Use this skill when:
- a service has no runbook and needs a baseline quickly
- existing runbooks are inconsistent and need a standard scaffold
- on-call or platform teams need deployment, incident, or rollback runbooks
- a mapped workflow needs to be converted into an operational procedure

## Workflow

1. Confirm the service name, owner, primary environment, and intended runbook
   location.
2. Generate the baseline runbook skeleton with the script.
3. Review the generated sections and replace placeholders with service-specific
   commands, URLs, checks, and escalation paths.
4. Use the reference template to add any missing deployment, incident, database,
   or validation details.
5. Confirm the runbook is stored near the target service or docs location and is
   ready for human review.

## Script Entry Point

Primary generator:

```bash
python3 scripts/runbook_generator.py <service> --owner <owner> --environment <environment> --output <path>
```

Useful modes:

```bash
# Preview to stdout first
python3 scripts/runbook_generator.py payments-api --owner platform --environment production

# Write a draft file
python3 scripts/runbook_generator.py payments-api --owner platform --environment production --output docs/runbooks/payments-api.md
```

## Artifact And Output Locations

- Default behavior prints the runbook draft to stdout.
- When `--output` is provided, the script writes a Markdown file to the chosen
  path.
- Typical target locations:
  - `docs/runbooks/<service>.md`
  - `runbooks/<service>.md`
  - another service-local docs path chosen by the user

The generated file is only a scaffold. It must be customized before operational
use.

## Validation Path

Minimum validation for this skill:

```bash
python3 scripts/runbook_generator.py --help
python3 -m py_compile scripts/runbook_generator.py
```

Recommended draft validation after generation:
- confirm commands are copy-pasteable
- add expected output or health checks after critical steps
- verify rollback triggers and escalation owners
- use the quarterly validation checklist in the reference file

## Non-Goals And Safety Notes

- Do not treat the generated skeleton as production-ready without customization.
- Do not invent service-specific commands, contacts, or health checks.
- Do not assume the default environment is correct for the user's task.
- Do not skip rollback or escalation sections just because the first draft is
  short.
- Do not mutate live systems as part of this generation step.

## References And Support Assets

- Script:
  - `scripts/runbook_generator.py`
- Reference:
  - `references/runbook-templates.md`
