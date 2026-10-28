---
name: python-code-implementer
description: Implement Python code based on an approved implementation plan while keeping scope minimal and controlled
argument-hint: "[task or module to implement]"
disable-model-invocation: false
---

# Skill: python-code-implementer

## Purpose
Implement approved Python changes with repo-native patterns, minimal change
surface, and concrete verification evidence.

## Trigger Conditions

Use this skill when:
- implementing a task that already has an approved plan or clear scope
- fixing Python bugs or adding bounded Python functionality
- modifying Python modules, services, CLIs, scripts, or libraries in an
  existing repository

Do not use this skill to create the plan from scratch. Use
`python-project-planner` or `python-implementation-planner` first when the
work is still in the design phase.

## Input Boundary

The user may provide:
- a specific implementation task
- an approved plan
- a target file, module, or feature
- a bug or missing behavior

If the request conflicts with the approved plan or the repo evidence, stop and
clarify before editing.

## Step Order (Mandatory)

1. Inspect the existing repo contract before editing.
2. Confirm the specific task and the target file or module boundary.
3. Implement the smallest working change that satisfies the task.
4. Update tests when behavior changes or a bug is fixed.
5. Run the strongest repo-native validation gates that are practical.
6. Report what changed, how it was verified, and what remains risky.

## Repo Contract

Before editing, inspect enough of the existing codebase to match:
- import style
- exception and error-handling patterns
- async model in use
- model/schema conventions
- test runner and fixture style
- naming and module layout

Also detect the Python project tooling surface:
- `pyproject.toml`
- `uv.lock`, `poetry.lock`, `requirements*.txt`
- `pytest.ini`, `pyproject.toml` pytest config, or `tox.ini`
- `ruff`, `mypy`, `pyright`, or repo-native validation scripts

Preserve existing boundaries between transport handlers, service logic, repositories,
clients, schemas, and tests when the repo already uses them.

## Evidence Expectations

- State the repo patterns that governed the implementation.
- State the files changed and their integration points.
- State the exact validation commands run and whether they passed.
- If a gate could not run, say so directly.

## Non-Goals

- Do not redesign the architecture while implementing one bounded task.
- Do not introduce new frameworks or conventions without a clear repo-level
  reason.
- Do not rewrite unrelated modules.
- Do not claim completion without verification evidence.
- Do not leave new wiring or exports implicit.

## Output Format

1. PATTERN SCAN SUMMARY

State the relevant repo patterns found before editing.

2. TASK UNDERSTANDING

State what is being implemented and where it connects.

3. IMPLEMENTATION

State the concrete code changes and integration points.

4. EVIDENCE

State the validation commands, outputs, and any limitations.

5. NEXT STEP

State the next bounded implementation or review step, or stop.
