---
name: tech-debt-tracker
description: Scan codebases for technical debt, score severity, track trends, and generate prioritized remediation plans. Use when users mention tech debt, code quality, refactoring priority, debt scoring, cleanup sprints, or code health assessment. Also use for legacy code modernization planning and maintenance cost estimation.
---

# Tech Debt Tracker

## Overview
Use this workbench to produce a debt inventory, prioritize remediation, and generate trend reporting from concrete repository evidence rather than from vague cleanup advice.

## When To Use
- The user wants a codebase-level technical debt scan with explicit findings.
- The task needs prioritization output for backlog planning, maintenance sprints, or modernization sequencing.
- Historical debt snapshots or repeated scans need to be turned into trend reporting.
- The request benefits from the bundled scripts instead of a purely narrative review.

## Do Not Use When
- The task is a narrow code review or bug investigation for a single change. Route those to the appropriate implementation or review skill.
- The user wants architecture design guidance without a scanning or prioritization workflow.
- You do not have repository access or sample input to support a debt inventory.

## Workflow
1. Confirm the target repository or sample directory, the desired output format, and whether the user needs scanning, prioritization, trend reporting, or all three.
2. Run `scripts/debt_scanner.py` against the target directory to create an evidence-backed inventory.
3. Run `scripts/debt_prioritizer.py` against the inventory using the framework that matches the planning context.
4. Run `scripts/debt_dashboard.py` when the user needs historical trend summaries or executive reporting.
5. Synthesize the results into a concise debt brief:
   - highest-severity items
   - systemic themes
   - prioritized remediation plan
   - clear caveats about heuristic findings

## Script Entry Points
- Scan a codebase:
  - `python3 scripts/debt_scanner.py <directory> --format json --output /tmp/tech-debt-tracker/scan.json`
- Prioritize an inventory:
  - `python3 scripts/debt_prioritizer.py /tmp/tech-debt-tracker/scan.json --framework wsjf --team-size 8 --output /tmp/tech-debt-tracker/backlog.json`
- Build a dashboard from snapshots:
  - `python3 scripts/debt_dashboard.py assets/historical_debt_2024-01-15.json assets/historical_debt_2024-02-01.json --output /tmp/tech-debt-tracker/dashboard.json`
- Build a dashboard from a directory of snapshots:
  - `python3 scripts/debt_dashboard.py --input-dir assets --period monthly --output /tmp/tech-debt-tracker/dashboard.json`

## Artifact And Output Locations
- Write generated working artifacts under `/tmp/tech-debt-tracker/` unless the user asks for a different location.
- Treat `assets/` as sample inputs and baselines, not as the default destination for new output.
- Treat `expected_outputs/` as format references for result shape and reporting expectations.

## Validation Path
- `python3 scripts/debt_scanner.py assets/sample_codebase --format json --output /tmp/tech-debt-tracker/scan.json`
- `python3 scripts/debt_prioritizer.py /tmp/tech-debt-tracker/scan.json --framework wsjf --team-size 8 --output /tmp/tech-debt-tracker/backlog.json`
- `python3 scripts/debt_dashboard.py assets/historical_debt_2024-01-15.json assets/historical_debt_2024-02-01.json --output /tmp/tech-debt-tracker/dashboard.json`
- `python3 -m py_compile scripts/*.py`

## Non-Goals And Safety Notes
- Do not treat heuristic scanner output as unquestionable truth; highlight where findings need human review.
- Do not mutate the scanned repository as part of the debt-tracking workflow.
- Do not promise exact delivery or ROI numbers from prioritization frameworks; present them as decision support.
- Do not replace targeted architecture or code review skills when the request is narrower than codebase debt management.

## Support Assets
- `references/debt-classification-taxonomy.md`
- `references/debt-frameworks.md`
- `references/prioritization-framework.md`
- `references/stakeholder-communication-templates.md`
- `assets/sample_debt_inventory.json`
- `expected_outputs/sample_scan_output.json`
- `expected_outputs/sample_prioritization_output.json`
- `expected_outputs/sample_dashboard_output.json`
