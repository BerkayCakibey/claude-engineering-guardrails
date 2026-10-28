---
name: "codebase-onboarding"
description: "Guides engineers through unfamiliar codebases with structured exploration paths and key-file identification"
---

# Codebase Onboarding

## Overview

Analyze an unfamiliar repository, collect repeatable onboarding facts, and
turn them into audience-specific onboarding material. Keep `SKILL.md`
orchestration-focused. Use the analyzer and templates in this directory
instead of embedding long documentation scaffolds directly in the main file.

## When To Use

- Onboarding a new team member or contractor
- Rebuilding stale project docs after large refactors
- Preparing internal handoff documentation
- Creating a standardized onboarding packet for services

## Do Not Use When

- The task is feature-path discovery for a current implementation task. Use
  `repo-navigator`.
- The task is architectural decision capture rather than onboarding output.
- The task is a deep code review or defect investigation.
- You cannot validate the setup or operational steps against the current repo
  state.

## Workflow

1. Run the analyzer against the target repository.
2. Capture the minimum factual surface needed for onboarding:
   - top-level structure
   - detected languages and frameworks
   - key configuration files
   - setup commands and verification steps
3. Choose the output audience:
   - junior contributor
   - senior engineer
   - contractor or scoped handoff
4. Draft or update the onboarding document using the template support files.
5. Verify any setup, test, or run commands you include before finalizing the
   handoff.

## Script Entry Points

```bash
python3 scripts/codebase_analyzer.py /path/to/repo

python3 scripts/codebase_analyzer.py /path/to/repo --json

python3 scripts/codebase_analyzer.py /path/to/repo --max-depth 3
```

`scripts/codebase_analyzer.py` supports:

- positional `path` to the target repository
- `--json` for machine-readable output
- `--max-depth <n>` to control top-level structure depth

## Artifact And Output Locations

- The analyzer prints its summary to stdout by default.
- `--json` still writes to stdout unless you redirect or capture the output.
- Final onboarding documents belong in the task-selected location, typically a
  repo `docs/` path or a handoff note, not inside this skill directory.

## Validation Path

- `python3 scripts/codebase_analyzer.py --help`
- Run the analyzer once against the target repository and confirm the detected
  structure, languages, and key files are plausible.
- If you update onboarding docs in the repo, verify the setup and verification
  commands you documented in the same change set.

## Non-Goals And Safety Notes

- Do not invent setup commands, environment assumptions, or ownership
  boundaries that the repo does not support.
- Do not turn onboarding docs into a general architecture essay when the
  audience needs a fast operational start.
- Do not skip troubleshooting and verification steps for claimed setup flows.
- Do not let onboarding output drift from the current repository state.

## Support Assets

- [scripts/codebase_analyzer.py](scripts/codebase_analyzer.py) - repo fact
  collector for onboarding inputs
- [references/onboarding-template.md](references/onboarding-template.md) -
  main onboarding document structure
- [references/output-format-templates.md](references/output-format-templates.md)
  - audience-specific output variants
