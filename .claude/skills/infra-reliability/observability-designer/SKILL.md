---
name: "observability-designer"
description: "Design SLO frameworks, alert optimization outputs, and dashboard specifications for a service with script-backed generators."
---

# Skill: observability-designer

## Purpose

Design observability artifacts for a service or system: SLO frameworks, alert
optimization outputs, and dashboard specifications. This is a script-backed
workbench that orchestrates reusable generators rather than teaching the whole
discipline inline.

## When To Use

Use this skill when:
- a service needs a first-pass SLI/SLO framework
- an existing alert set needs analysis or noise reduction
- a team needs a dashboard specification for SRE, developer, executive, or ops
  use
- workflow or reliability analysis reveals monitoring gaps that need a concrete
  design artifact

Use domain implementation skills when the task is instrumenting code rather
than designing the observability contract.

## Workflow

1. Identify the service or system being modeled:
   - name
   - type
   - criticality
   - whether it is user-facing
   - intended consumer of the output
2. Choose the workbench mode:
   - SLO design
   - alert optimization
   - dashboard generation
3. Prepare the input:
   - a service definition JSON
   - or an alert configuration JSON
   - or direct CLI parameters for smaller runs
4. Create the target output directory when the chosen artifact path does not
   already exist.
5. Run the appropriate script and write artifacts to a chosen output path.
6. Review the generated artifact against the bundled references and expected
   outputs.
7. Validate the script path and sample generation before handing off the
   result.

## Script Entry Points

### SLO Framework Generation

```bash
python3 scripts/slo_designer.py --input assets/sample_service_api.json --output /tmp/observability/slo-framework.json
```

or

```bash
python3 scripts/slo_designer.py --service-type api --criticality high --user-facing true --service-name payment-service --output /tmp/observability/slo-framework.json
```

### Alert Analysis Or Optimization

```bash
python3 scripts/alert_optimizer.py --input assets/sample_alerts.json --analyze-only
python3 scripts/alert_optimizer.py --input assets/sample_alerts.json --output /tmp/observability/optimized-alerts.json
```

### Dashboard Specification Generation

```bash
python3 scripts/dashboard_generator.py --input assets/sample_service_web.json --output /tmp/observability/dashboard.json
```

or

```bash
python3 scripts/dashboard_generator.py --service-type web --name "Customer Portal" --role developer --output /tmp/observability/dashboard.json --doc-output /tmp/observability/dashboard.md
```

## Artifact And Output Locations

This workbench generates user-chosen artifact paths. Typical outputs include:
- SLO framework JSON
- optimized alert JSON
- alert analysis report
- dashboard JSON
- optional dashboard documentation Markdown

The parent directory for output files must already exist. Create it first when
using nested output paths, for example:

```bash
mkdir -p /tmp/observability-designer
```

Bundled examples live here:
- `expected_outputs/sample_slo_framework.json`
- `expected_outputs/sample_dashboard.json`

Bundled sample inputs live here:
- `assets/sample_service_api.json`
- `assets/sample_service_web.json`
- `assets/sample_alerts.json`

## Validation Path

Minimum validation for this skill:

```bash
python3 scripts/slo_designer.py --help
python3 scripts/alert_optimizer.py --help
python3 scripts/dashboard_generator.py --help
python3 -m py_compile scripts/slo_designer.py scripts/alert_optimizer.py scripts/dashboard_generator.py
```

Recommended sample validation:
- generate an SLO framework from a bundled sample input
- run alert analysis on the bundled sample alert file
- generate a dashboard from a bundled sample service definition
- compare the structure of generated outputs against `expected_outputs/`

## Non-Goals And Safety Notes

- Do not treat generated SLOs, alerts, or dashboards as production-ready without
  human review.
- Do not imply deployment or live monitoring-system access; this workbench
  generates design artifacts only.
- Do not use the scripts as a substitute for confirming user priorities,
  service criticality, or operational ownership.
- Do not duplicate long cookbook or pattern guidance into `SKILL.md`.
- Do not widen the task into implementation, vendor migration, or incident
  response execution unless another skill owns that step.

## References And Support Assets

- Scripts:
  - `scripts/slo_designer.py`
  - `scripts/alert_optimizer.py`
  - `scripts/dashboard_generator.py`
- References:
  - `references/slo_cookbook.md`
  - `references/alert_design_patterns.md`
  - `references/dashboard_best_practices.md`
- Assets:
  - `assets/sample_service_api.json`
  - `assets/sample_service_web.json`
  - `assets/sample_alerts.json`
- Expected outputs:
  - `expected_outputs/sample_slo_framework.json`
  - `expected_outputs/sample_dashboard.json`
