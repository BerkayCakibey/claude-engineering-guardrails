---
name: python-dev-preflight
description: Prepare a Python project environment before development begins
argument-hint: "[project directory]"
disable-model-invocation: false
---

# Skill: python-dev-preflight

## Purpose
Prepare a Python project environment before implementation begins. Use this
workflow to verify the project directory, package manager, environment, and
baseline tooling so development does not start on a broken setup.

## Trigger Conditions
Use this skill when:
- starting work in a Python repository
- creating a new Python project and preparing the environment
- a Python task chain explicitly requires environment preflight before coding
- environment drift is likely to block implementation or validation

If the project directory is unclear, ask before continuing.

## Input Boundary
The user may provide:
- a project directory
- a new Python project idea
- an existing repository

All setup guidance must stay inside the target project scope.

## Step Order (Mandatory)
1. Identify the project directory.
2. Detect the package manager before recommending any setup command.
3. Confirm the required Python version.
4. Verify the local environment and dependency state.
5. Verify the expected lint, format, and test tooling.
6. Recommend the smallest validation command set that proves the environment is ready.

## Package Manager Detection
This step is mandatory before anything else.

Check for:
- `pyproject.toml` with `[tool.uv]` or `uv.lock` -> uv project
- `uv.lock` -> uv project
- `Pipfile` -> pipenv project
- `poetry.lock` -> poetry project
- `requirements.txt` only -> plain pip + venv project

If uv is detected, use uv commands throughout. Do not suggest pip or venv for
a uv project.

## Environment Rules
For uv projects:
- confirm `uv` is installed with `uv --version`
- sync the environment with `uv sync`
- run tools with `uv run <tool>`

For plain pip projects:
- confirm `python3 --version`
- create `.venv` if needed with `python3 -m venv .venv`
- activate with `source .venv/bin/activate`
- install dependencies from `requirements.txt`

For all project types:
- prefer project-local environments
- do not recommend global tool installation when the repo already provides a local path
- do not recommend both `black` and `ruff` for formatting if `ruff` already covers the workflow

## Evidence Expectations
- State the resolved project directory.
- State the detected package manager and why it was chosen.
- State the required or observed Python version signal.
- State whether dependencies and core tools are ready.
- Recommend the smallest validation commands that prove the environment works.

## Non-Goals
- Do not assume pip or venv before detecting the package manager.
- Do not install system packages.
- Do not modify files outside the project directory.
- Do not add extra tooling complexity the repo does not need.

## Output Format
1. PROJECT LOCATION

State the project directory and confirm that work should stay inside it.

2. PACKAGE MANAGER

State the detected package manager and the matching setup commands.

3. PYTHON VERSION CHECK

State the version requirement signal and how to verify it locally.

4. DEPENDENCY STATUS

State whether dependencies need sync or installation.

5. TOOLING CHECK

State the expected lint, format, and test tools and how they should be run.

6. PROJECT STRUCTURE CHECK

State whether the basic project structure is present and whether anything
important appears to be missing.

7. FIRST VALIDATION

Provide the smallest command set that proves the environment is ready before
code changes begin.
