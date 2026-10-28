---
name: "dependency-auditor"
description: "Audits project dependencies for vulnerabilities, license issues, and outdated packages"
---

# Skill: dependency-auditor

## Overview

Use this skill to audit a repository's dependency surface for security,
licensing, maintenance, and upgrade risk using the bundled scanners and
reference material. Keep `SKILL.md` orchestration-focused. The long tool
details, sample artifacts, and background guidance already live in this
directory's support files.

These helpers use a limited embedded advisory set and simulated upgrade
versions. They do not provide a current vulnerability audit or live upgrade
recommendations.

## When To Use

- The user wants dependency vulnerability or supply-chain review.
- The task needs license compliance or license-conflict analysis.
- The task needs a dependency inventory, stale-package review, or upgrade plan.
- Code review or security review work explicitly expands into dependency risk.

## Do Not Use When

- The task is general source-code review without dependency scope.
- The task is package installation, lockfile repair, or upgrade execution.
- The task needs runtime security analysis of application code rather than the
  dependency graph.
- The repository or manifest location is still unclear. Use `repo-navigator`
  first.

## Workflow

1. Identify the repository root and the package ecosystems in scope.
2. Run the smallest useful helper first:
   - `dep_scanner.py` for dependency inventory and vulnerability signals
   - `license_checker.py` for compliance and compatibility analysis
   - `upgrade_planner.py` once an inventory exists and upgrade planning is needed
3. Review the reported dependency paths, version data, and risk categories
   before treating any output as final.
4. Turn confirmed results into an evidence-backed report with severity,
   affected packages, and next steps.
5. If upgrades are recommended, pair them with repo-native test expectations
   and rollback awareness instead of treating the planner output as
   self-sufficient proof.

## Script Entry Points

Dependency and vulnerability scan:

```bash
python3 scripts/dep_scanner.py /path/to/project
python3 scripts/dep_scanner.py . --format json --output /tmp/dependency-auditor/deps.json
```

License compliance analysis:

```bash
python3 scripts/license_checker.py /path/to/project
python3 scripts/license_checker.py . --inventory /tmp/dependency-auditor/deps.json --format json --output /tmp/dependency-auditor/licenses.json
```

Upgrade plan generation:

```bash
python3 scripts/upgrade_planner.py /tmp/dependency-auditor/deps.json
python3 scripts/upgrade_planner.py /tmp/dependency-auditor/deps.json --security-only --format json --output /tmp/dependency-auditor/upgrade-plan.json
```

## Artifact And Output Locations

- All three scripts print to stdout by default.
- `--output <path>` writes task-selected artifacts outside the skill directory.
- Recommended task-local artifact paths look like:
  - `/tmp/dependency-auditor/deps.json`
  - `/tmp/dependency-auditor/licenses.json`
  - `/tmp/dependency-auditor/upgrade-plan.json`
- Stable sample inputs live under `assets/`.
- Example report contracts live under `expected_outputs/`.
- Use the target repository or a task-local temp directory for generated audit
  files. Do not write reports into this skill directory during normal use.

## Validation Path

- `python3 scripts/dep_scanner.py --help`
- `python3 scripts/license_checker.py --help`
- `python3 scripts/upgrade_planner.py --help`
- Run `dep_scanner.py` against the target repository or the bundled
  `test-project/`, then feed the resulting inventory into `license_checker.py`
  or `upgrade_planner.py` when those lanes are in scope.

## Non-Goals And Safety Notes

- Do not treat script output as confirmed exploitability without checking the
  actual dependency path and repository context.
- Do not present license analysis as legal approval or legal advice.
- Do not recommend broad dependency upgrades without stating test and rollback
  expectations.
- Do not skip lockfile or manifest evidence when the repository depends on
  deterministic builds.
- Do not mutate dependency manifests or lockfiles unless the user explicitly
  asked for remediation work after the audit.

## Support Assets

- [scripts/dep_scanner.py](scripts/dep_scanner.py) - dependency inventory and
  vulnerability scanning
- [scripts/license_checker.py](scripts/license_checker.py) - license compliance
  and conflict analysis
- [scripts/upgrade_planner.py](scripts/upgrade_planner.py) - staged upgrade and
  risk planning
- [references/vulnerability_assessment_guide.md](references/vulnerability_assessment_guide.md) -
  vulnerability triage guidance
- [references/license_compatibility_matrix.md](references/license_compatibility_matrix.md) -
  license compatibility reference
- [references/dependency_management_best_practices.md](references/dependency_management_best_practices.md) -
  maintenance and upgrade guidance
- [README.md](README.md) - operator-facing overview for maintainers
- `assets/` - sample manifests and lock-style inputs
- `expected_outputs/` - example output contracts
