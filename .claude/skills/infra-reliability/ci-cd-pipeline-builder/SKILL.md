---
name: "ci-cd-pipeline-builder"
description: "Builds and validates CI/CD pipeline configurations for reliable deployment workflows"
---

# CI/CD Pipeline Builder

## Overview

Use this skill to detect a repository stack and generate a pragmatic CI/CD
baseline from those signals. Keep `SKILL.md` orchestration-focused. Use the
bundled scripts and references for detection, generation, and deployment-gate
guidance instead of embedding long template material in the main file.

## When To Use

- Bootstrapping CI for a new repository
- Replacing brittle copied pipeline files
- Migrating between GitHub Actions and GitLab CI
- Auditing whether pipeline steps match actual stack
- Creating a reproducible baseline before custom hardening

## Do Not Use When

- The task is a narrow production change to an existing pipeline without a full
  pipeline-generation boundary.
- The user needs architecture advice for cloud topology rather than CI/CD
  config generation.
- The repo already has a mature pipeline and the change is only a small
  one-line edit.
- Required secrets, protected environments, or deployment approvals are still
  undefined.

## Workflow

1. Detect the real repository stack before writing pipeline YAML.
2. Confirm which stages are actually supported by the repo:
   - `lint`
   - `test`
   - `build`
   - `deploy`
3. Generate the smallest reliable baseline for the target platform.
4. Add caching, matrix behavior, and deployment stages only when the stack and
   repo workflow justify them.
5. Validate the generated pipeline against the repo commands and the target
   CI platform expectations.

## Script Entry Points

Detect stack signals:

```bash
python3 scripts/stack_detector.py --repo . --format text
python3 scripts/stack_detector.py --repo . --format json
```

Generate pipeline YAML:

```bash
python3 scripts/pipeline_generator.py --repo . --platform github --output .github/workflows/ci.yml --format text
python3 scripts/pipeline_generator.py --input detected-stack.json --platform gitlab --output .gitlab-ci.yml --format text
```

`scripts/stack_detector.py` supports:
- `--repo <path>` to scan a repository directly
- `--input <path>` for precomputed signals
- `--format text|json`

`scripts/pipeline_generator.py` supports:
- `--repo <path>` for auto-detection fallback
- `--input <path>` for stack report JSON
- `--platform github|gitlab`
- `--output <path>` to write the generated YAML
- `--format text|json` for generation summary output

## Artifact And Output Locations

- `stack_detector.py` prints detection output to stdout unless the caller
  redirects or captures it.
- `pipeline_generator.py` prints YAML to stdout by default and writes to the
  selected file when `--output` is provided.
- Common generated artifact paths are:
  - `.github/workflows/ci.yml`
  - `.gitlab-ci.yml`
  - `/tmp/detected-stack.json`
- Keep generated pipelines in the target repo, not in this skill directory.

## Validation Path

- `python3 scripts/stack_detector.py --help`
- `python3 scripts/pipeline_generator.py --help`
- Generate one detection report and one pipeline output before finalizing the
  baseline.
- Confirm the referenced repo commands exist and that secrets are documented
  outside the YAML.

## Non-Goals And Safety Notes

- Do not copy template YAML across stacks without detection.
- Do not embed secrets in generated YAML.
- Do not enable production deploy jobs without explicit branch or environment gates.
- Do not treat generated YAML as final proof until it has been parsed and
  matched against the repo's real commands.
- Do not expand into cloud architecture, rollout automation, or incident
  response design unless the task explicitly requires it.

## Support Assets

- [scripts/stack_detector.py](scripts/stack_detector.py) - repository signal
  detector
- [scripts/pipeline_generator.py](scripts/pipeline_generator.py) - GitHub and
  GitLab pipeline generator
- [references/github-actions-templates.md](references/github-actions-templates.md)
  - GitHub Actions patterns
- [references/gitlab-ci-templates.md](references/gitlab-ci-templates.md) -
  GitLab CI patterns
- [references/deployment-gates.md](references/deployment-gates.md) -
  deployment gate guidance
