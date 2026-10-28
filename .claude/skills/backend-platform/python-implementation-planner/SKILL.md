---
name: python-implementation-planner
description: Convert an approved Python project plan into concrete implementation steps and file-level tasks
argument-hint: "[project name or approved plan]"
disable-model-invocation: false
---

# Skill: python-implementation-planner

## Purpose
Convert an approved Python plan into concrete implementation order, file-level
tasks, and integration points without drifting into code generation.

## Trigger Conditions

Use this skill when:
- a Python project plan has already been approved
- a Python feature needs to be broken into concrete implementation tasks
- the user needs file-level sequencing before using
  `python-code-implementer`

## Input Boundary

The user may provide:
- an approved project plan
- a Jira task or feature plan
- repository structure
- module descriptions
- a specific feature to add

If the plan is missing or still ambiguous, ask for the planning output before
continuing.

## Step Order (Mandatory)

1. Detect whether the work is `new-project` or `extend-existing`.
2. For `extend-existing`, inspect the current codebase before planning tasks.
3. Summarize the project purpose and the implementation target.
4. Produce the implementation order and file-level responsibilities.
5. Break the work into small executable tasks.
6. Add dependency setup only when it is actually required.
7. Define the minimal test strategy and hand off to
   `python-code-implementer`.

## Mode Rules

- `new-project`
  - include initialization, dependency setup, baseline structure, and first
    implementation phases
- `extend-existing`
  - skip repo initialization
  - read existing module, error-handling, import, and test patterns first
  - make integration points explicit by file and function name where possible

## Evidence Expectations

- State the detected mode and why it applies.
- For `extend-existing`, state the existing code patterns that shape the plan.
- State the file-level plan and the concrete handoff order.
- Keep the plan incremental and executable.

## Non-Goals

- Do not generate full code implementations here.
- Do not expand scope beyond the approved plan.
- Do not assume repo structure in `extend-existing` mode without reading it.
- Do not add unnecessary dependencies or architecture.

## Output Format

1. MODE AND PROJECT SUMMARY

State `new-project` or `extend-existing` and summarize the target outcome.

2. EXISTING CODE REVIEW

For `extend-existing`, state the patterns and integration points found.

3. IMPLEMENTATION ORDER

State the recommended build order and why it is safe.

4. FILE IMPLEMENTATION PLAN

State each new or modified file and its responsibility.

5. DEVELOPMENT TASK LIST

State the sequential tasks.

6. DEPENDENCY SETUP

State required dependencies only when needed.

7. TEST STRATEGY OVERVIEW

State the minimum tests needed.

8. HANDOFF

State the next step for `python-code-implementer`.
