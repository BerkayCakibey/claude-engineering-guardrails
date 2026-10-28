---
name: skill-creator
description: Create or upgrade Codex and Claude skills using the current governance model, then validate the result with evals, packaging, and repository-appropriate checks. Use when a user wants a new skill, a skill rewrite, trigger tuning, or a packaged `.skill` handoff.
argument-hint: "[skill path or new skill goal]"
disable-model-invocation: false
---

# Skill Creator

## Overview

Use this skill to create a new skill, improve an existing skill, or run a
structured evaluation loop on a skill boundary. Keep `SKILL.md`
orchestration-focused. Put long schemas, fixtures, viewer assets, and
automation in this directory's support files instead of repeating them in the
main prompt surface.

## When To Use

Use this skill when:

- creating a new skill from scratch
- rewriting or normalizing an existing skill
- adding evals or comparison runs for a skill that needs measurable evidence
- tuning frontmatter description text so the right queries trigger the skill
- packaging a finished skill into a `.skill` archive

Use a smaller workflow instead when:

- the task is only to validate an existing skill against repo governance
- the task is only to route to the correct existing skill
- the user wants lightweight brainstorming without creating or editing a skill
  artifact

## Workflow

1. Define the boundary first.
   - Confirm what the skill should do, when it should trigger, what it must
     not absorb, and what output or artifact contract it should enforce.
   - Preserve the routed name when updating an installed or repo-active skill
     unless repo evidence clearly requires a rename.
2. Draft or revise the skill structure.
   - Choose the correct governance form before writing.
   - Keep invocation instructions in `SKILL.md`.
   - Move large examples, schemas, fixtures, and reusable automation into
     support assets.
3. Validate the draft before heavy testing.
   - From this directory, run `python3 -m scripts.quick_validate <skill-dir>`
     for the packaged-skill surface.
   - If the skill is active in a maintained catalog, also run that catalog's
     own validation checks before calling the structure acceptable.
4. Prepare the evaluation scope.
   - Decide whether the skill needs qualitative review only or paired baseline
     comparison.
   - Put durable prompts in `<skill-dir>/evals/evals.json` when the skill needs
     a maintained eval set.
   - Create a sibling workspace only when runs actually start:
     `<skill-dir>-workspace/iteration-N/...`
5. Run the smallest useful evaluation loop.
   - For workflow or automation skills, compare the new skill against
     `without_skill` or an old-skill snapshot.
   - While runs are in progress, draft or refine assertions and save them with
     the eval metadata.
   - Grade outputs, aggregate benchmark data, and generate a review viewer
     before rewriting again.
6. Tighten description and finish packaging.
   - Only run trigger-description optimization after the skill body is stable.
   - Package the final skill when the user needs a distributable artifact.
   - Return a concise summary of the boundary, evidence, and next maintenance
     hooks.

## Script Entry Points

Run these from `.claude/skills/meta-catalog/skill-creator/` unless this directory is already
on `PYTHONPATH`.

- Structural validator:
  - `python3 -m scripts.quick_validate <skill-dir>`
  - Use for required frontmatter, approved runtime fields, and basic shape
    checks.
- Packager:
  - `python3 -m scripts.package_skill <skill-dir> [output-dir]`
  - Produces `<output-dir>/<skill-name>.skill`.
- Benchmark aggregator:
  - `python3 -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name> --skill-path <skill-dir>`
  - Writes `benchmark.json` and `benchmark.md`.
- Description trigger evaluator:
  - `python3 -m scripts.run_eval --eval-set <path> --skill-path <skill-dir> [--description <text>] [--model <id>]`
  - Use only when the environment has `claude -p` available.
- Description optimization loop:
  - `python3 -m scripts.run_loop --eval-set <path> --skill-path <skill-dir> --model <id> [--report none] [--results-dir <dir>]`
  - Use `--report none` in headless environments.
- Review viewer:
  - `python3 eval-viewer/generate_review.py <workspace>/iteration-N --skill-name <name> --benchmark <workspace>/iteration-N/benchmark.json`
  - Add `--previous-workspace <workspace>/iteration-(N-1)` for iteration
    comparisons.
  - Add `--static <output.html>` when you need a standalone file instead of a
    local server.

## Artifact Locations

- Skill source:
  - `<skill-dir>/SKILL.md`
  - optional `<skill-dir>/scripts/`, `references/`, `assets/`,
    `expected_outputs/`, `evals/`
- Evaluation workspace:
  - sibling directory `<skill-dir>-workspace/`
- Per-iteration run layout:
  - `iteration-N/<eval-name-or-id>/<configuration>/outputs/`
  - `iteration-N/<eval-name-or-id>/<configuration>/grading.json`
  - `iteration-N/<eval-name-or-id>/<configuration>/timing.json`
- Shared iteration artifacts:
  - `iteration-N/benchmark.json`
  - `iteration-N/benchmark.md`
  - `iteration-N/feedback.json`
- Packaged output:
  - `[output-dir]/<skill-name>.skill`

## Evaluation Guidance

- Use 2-3 realistic prompts first. Expand only after the boundary is stable.
- Prefer baseline comparisons for skills with objective outputs or workflow
  claims.
- Prefer qualitative human review for subjective writing or design skills.
- Do not force quantitative assertions onto tasks that depend on taste or
  open-ended judgment.
- If repeated executor runs independently invent the same helper script or
  template, bundle it into the skill instead of paying that cost every run.

## Example Commands

Quick validation:

```bash
cd .claude/skills/meta-catalog/skill-creator
python3 -m scripts.quick_validate ../repo-navigator
```

Package a finished skill:

```bash
cd .claude/skills/meta-catalog/skill-creator
python3 -m scripts.package_skill ../repo-navigator /tmp/skill-packages
```

Aggregate one evaluation iteration:

```bash
cd .claude/skills/meta-catalog/skill-creator
python3 -m scripts.aggregate_benchmark /tmp/repo-navigator-workspace/iteration-1 \
  --skill-name repo-navigator \
  --skill-path /path/to/repo/.claude/skills/meta-catalog/repo-navigator
```

Generate a static reviewer page:

```bash
cd .claude/skills/meta-catalog/skill-creator
python3 eval-viewer/generate_review.py /tmp/repo-navigator-workspace/iteration-1 \
  --skill-name repo-navigator \
  --benchmark /tmp/repo-navigator-workspace/iteration-1/benchmark.json \
  --static /tmp/repo-navigator-review.html
```

## Validation Path

For packaged or external skills:

- `python3 -m scripts.quick_validate <skill-dir>`

## Validation Guidance

These checks are enough for copied or packaged usage:

- `python3 -m scripts.quick_validate <skill-dir>`
- confirm any referenced support files, examples, and commands are present in
  the copied package
- confirm no repo-local maintainer paths are required

If the skill is active inside a larger repository, maintainers may also run
that repository's own catalog validators and regenerate any derived indexes
there. Do not assume a copied setup includes maintainer-only tooling.

If the skill adds compact cards or other family-sensitive surfaces, also run
the narrower validators available in that repository.

## Non-Goals

- Do not rename an existing routed skill unless repo evidence clearly forces
  it.
- Do not keep giant examples, environment lore, or general theory in
  `SKILL.md` when they belong in support assets.
- Do not run a heavy benchmark loop when the user only wants a quick draft or a
  bounded wording fix.
- Do not claim trigger-quality improvements from description tuning alone if
  the skill body is still structurally wrong.
- Do not treat obsolete tier systems, line-count gates, or legacy path
  conventions as current governance.

## Safety Notes

- If the task is "fix the active repo skill catalog," follow repo governance
  first and use this skill to implement within that model, not to invent a new
  one.
- When updating an existing skill, preserve the installed name and snapshot the
  old version before using it as a baseline.
- Use subagents or delegated comparison runs only when the runtime allows it
  and the user asked for or accepted that evaluation mode.
- Stop and narrow the batch if the next correction would spill into a broad
  rename, merge, or cross-catalog rewrite.

## Support Index

- Schemas: [references/schemas.md](references/schemas.md)
- Grading guidance: [agents/grader.md](agents/grader.md)
- Blind comparison guidance: [agents/comparator.md](agents/comparator.md)
- Benchmark analysis guidance: [agents/analyzer.md](agents/analyzer.md)
- Eval review template: [assets/eval_review.html](assets/eval_review.html)
- Review viewer: [eval-viewer/generate_review.py](eval-viewer/generate_review.py)
