---
description: Start a Python development task — routes through the skill chain
argument-hint: "[task description or Jira ticket]"
---

# Python Task

Entry point for all Python development work — new features, extensions, and Jira implementation tasks.

## Step 1: Route the task

Use the Skill tool to invoke task-dispatcher:
- skill: task-dispatcher
- Pass the full task description from the user argument (`$ARGUMENTS`)

Wait for task-dispatcher to classify the task and define the CORE + CONDITIONAL skill chain.

## Step 2: Follow the skill chain

Execute only the skills that task-dispatcher selected. Do not add extra skills beyond what was approved.

CORE chain (always runs for Python extend):

1. Invoke `repo-navigator` — locate relevant files and extract existing patterns
2. Invoke `python-implementation-planner` — produce a step-by-step plan, wait for user approval
3. Invoke `python-code-implementer` — implement each approved task
4. Invoke `self-check` — verify logic, wiring, and pipeline completeness
5. If self-check returns REQUIRES FIXES: fix issues, re-run self-check until PASS

Additional skills are added only when task-dispatcher includes them (e.g. test-strategy-planner, python-security-review). Do not invoke them by default.

For Python — new project:

Insert `python-project-planner` before `python-implementation-planner` and `python-dev-preflight` before `python-code-implementer`.

## Rules

- Never skip repo-navigator when working in an existing codebase
- Never write code before an approved plan exists
- Always run self-check after implementation
- Follow task-dispatcher's chain — do not add or skip skills without user approval
- Stop and ask the user before expanding scope beyond the approved plan
