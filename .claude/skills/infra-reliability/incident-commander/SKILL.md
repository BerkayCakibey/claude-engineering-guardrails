---
name: "incident-commander"
description: "Coordinate incident triage, timeline reconstruction, stakeholder updates, and PIR generation."
---

# Skill: incident-commander

## Overview

Coordinate incident triage, timeline reconstruction, communications, and
post-incident follow-up without turning `SKILL.md` into a full incident
handbook. Use the bundled scripts, templates, and references to keep outputs
factual, time-ordered, and blameless.

## When To Use

- The user needs incident severity classification or structured triage.
- Logs, alerts, deploys, or operator actions must be reconstructed into a
  timeline.
- A stakeholder update, status message, or PIR must be drafted from evidence.
- A live response, retrospective, or incident simulation needs a consistent
  response framework.

## Do Not Use When

- The task is generic debugging without incident leadership or communication
  scope.
- The repository or service boundary is still unclear. Use `repo-navigator`
  first.
- The task is only code remediation, not incident coordination.
- The user only needs a narrow security or dependency audit rather than
  response coordination.

## Workflow

1. Start with scope:
   - what failed
   - who is affected
   - whether this is live response, retrospective, or simulation
2. Classify severity conservatively and state the confidence level.
3. Split the work into the needed lanes:
   - triage
   - timeline
   - communication
   - PIR and follow-up
4. Use the smallest useful helper first rather than running every script.
5. Keep all outputs factual, ordered by time, and explicit about unknowns.
6. Convert script output and reference guidance into stakeholder-ready artifacts.

## Script Entry Points

Severity and initial-response classification:

```bash
python3 scripts/incident_classifier.py --input incident.json --format text
python3 scripts/severity_classifier.py --input incident.json --format text
```

Timeline reconstruction:

```bash
python3 scripts/timeline_reconstructor.py --input events.json --format markdown --gap-analysis
python3 scripts/incident_timeline_builder.py --input events.json --output /tmp/incident-commander/timeline.json
```

PIR and postmortem generation:

```bash
python3 scripts/pir_generator.py --incident incident.json --timeline timeline.json --format markdown --output /tmp/incident-commander/pir.md
python3 scripts/postmortem_generator.py --incident incident.json --format markdown --output /tmp/incident-commander/postmortem.md
```

## Artifact And Output Locations

- All scripts write to stdout by default unless `--output` is supplied.
- Recommended task-local artifact paths look like:
  - `/tmp/incident-commander/classification.txt`
  - `/tmp/incident-commander/timeline.md`
  - `/tmp/incident-commander/pir.md`
- Stable input fixtures live under `assets/`.
- Example artifact contracts live under `expected_outputs/`.
- Checked-in incident records should only be written into the target repository
  when the task explicitly calls for it.

## Validation Path

- `python3 scripts/incident_classifier.py --help`
- `python3 scripts/timeline_reconstructor.py --help`
- `python3 scripts/pir_generator.py --help`
- Run at least one classifier or timeline command against a task input or the
  bundled sample assets before relying on the workflow output.

## Non-Goals And Safety Notes

- Do not speculate about root cause, blast radius, or customer impact when the
  evidence is still incomplete.
- Do not hide unknowns or rewrite timeline uncertainty as certainty.
- Do not generate blame-focused PIR language.
- Do not treat template output as complete without checking timestamps,
  responders, and impact claims.
- Do not collapse live response guidance and retrospective analysis into one
  unstructured report.

## Support Assets

- [scripts/incident_classifier.py](scripts/incident_classifier.py) - incident
  classification and first-response guidance
- [scripts/severity_classifier.py](scripts/severity_classifier.py) - focused
  severity analysis
- [scripts/timeline_reconstructor.py](scripts/timeline_reconstructor.py) -
  ordered timeline reconstruction and gap analysis
- [scripts/incident_timeline_builder.py](scripts/incident_timeline_builder.py) -
  timeline artifact generation
- [scripts/pir_generator.py](scripts/pir_generator.py) - PIR generation
- [scripts/postmortem_generator.py](scripts/postmortem_generator.py) -
  postmortem generation
- [references/incident-response-framework.md](references/incident-response-framework.md) -
  response process guidance
- [references/incident_severity_matrix.md](references/incident_severity_matrix.md) -
  severity matrix
- [references/communication_templates.md](references/communication_templates.md) -
  stakeholder update templates
- [references/rca_frameworks_guide.md](references/rca_frameworks_guide.md) -
  RCA framework selection
- [references/sla-management-guide.md](references/sla-management-guide.md) -
  SLA and response-timing guidance
- [references/reference-information.md](references/reference-information.md) -
  supporting reference material
- `assets/` - incident fixtures and reusable templates
- `expected_outputs/` - sample report contracts
- [README.md](README.md) - maintainer overview and deeper usage examples
