---
name: "agent-workflow-designer"
description: "Designs multi-agent workflows with routing logic, parallel execution, and result aggregation"
---

# Agent Workflow Designer

## Overview

Use this skill to design multi-agent workflows with explicit routing,
handoff contracts, budget controls, and failure handling. Keep `SKILL.md`
focused on orchestration. Use the scaffolder and pattern reference as support
surfaces instead of turning the main file into a long workflow handbook.

## When To Use

- A single prompt or single agent is no longer enough for the task boundary.
- You need a deterministic workflow shape before implementation.
- The workflow needs explicit parallelism, routing, validation loops, or
  result aggregation.
- The user needs a starting config or design skeleton for a multi-agent
  system.

## Do Not Use When

- One well-bounded prompt or one specialist agent can handle the task.
- The user needs implementation of an existing workflow, not workflow design.
- The task is only to pick the right local skill for a request. Use
  `task-dispatcher`.
- The workflow has unresolved product or ownership boundaries that should be
  clarified before orchestration design.

## Workflow

1. Define the job boundary first.
   - What outcome should the workflow produce?
   - Which steps genuinely need separate agents?
   - What context must each step receive, and what must stay out?
2. Choose the smallest viable pattern.
   - `sequential` for strict dependency chains.
   - `parallel` for independent fan-out/fan-in work.
   - `router` for intent or type-based dispatch.
   - `orchestrator` for planner-led specialist coordination.
   - `evaluator` for generator plus validation loop.
3. Scaffold the initial config with `scripts/workflow_scaffolder.py`.
4. Define the runtime contract for each edge:
   - handoff payload fields
   - retry and timeout policy
   - validation or acceptance gate
   - failure escalation path
5. Dry-run on a small context budget before scaling the workflow shape.

## Script Entry Points

Generate a starter workflow skeleton:

```bash
python3 scripts/workflow_scaffolder.py sequential --name content-pipeline
python3 scripts/workflow_scaffolder.py orchestrator --name incident-triage --output workflows/incident-triage.json
```

`scripts/workflow_scaffolder.py` supports:

- positional `pattern`: `sequential`, `parallel`, `router`, `orchestrator`,
  or `evaluator`
- `--name <workflow-name>` for naming the scaffold
- `--output <path>` for writing JSON to a file instead of stdout

## Artifact And Output Locations

- By default the scaffolder prints the generated JSON workflow skeleton to
  stdout.
- With `--output <path>`, it writes a JSON scaffold to the task-selected
  location, commonly something like `workflows/<name>.json`.
- Keep supporting design notes, handoff contracts, and validation rules in the
  consumer repo or task notes rather than embedding them in this skill.

## Validation Path

- `python3 scripts/workflow_scaffolder.py --help`
- Generate one sample scaffold to stdout or a temp file and confirm the
  selected pattern, workflow name, and JSON shape are correct.
- If the scaffold is checked into another repo, validate it in that repo's
  own runtime or config-loading path before calling the workflow ready.

## Non-Goals And Safety Notes

- Do not split work across agents when a single bounded prompt is sufficient.
- Do not pass full upstream context through every edge by default.
- Do not treat the generated skeleton as production-ready without explicit
  handoff, retry, timeout, and validation design.
- Do not hide provider assumptions, cost limits, or escalation paths in
  implicit defaults.

## Support Assets

- [scripts/workflow_scaffolder.py](scripts/workflow_scaffolder.py) - starter
  JSON scaffolder for the supported workflow patterns
- [references/workflow-patterns.md](references/workflow-patterns.md) -
  detailed pattern tradeoffs and example workflow shapes
