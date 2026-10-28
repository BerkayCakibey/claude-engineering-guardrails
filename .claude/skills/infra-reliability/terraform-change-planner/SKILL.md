---
name: terraform-change-planner
description: Plan a minimal Terraform change based on a specific task
argument-hint: "[task description]"
disable-model-invocation: false
---

# Skill: terraform-change-planner

## Purpose
Locate the correct Terraform file and plan the minimum required change for a
bounded task. Use this skill to keep Terraform work narrow, explicit, and safe
before any edit is made.

## Trigger Conditions

Use this skill when:
- the task is a small Terraform change
- the correct file, module, or environment must be located first
- the user needs a minimal change plan rather than a broad Terraform review
- an ops workflow has already scoped the task and now needs the exact Terraform
  boundary

If multiple candidate files or environments are plausible, stop and ask before
planning an edit.

## Input Boundary

The user may provide:
- task description
- environment
- repository
- module location
- service or component name

Do not infer the target environment or module if the repository contains
multiple plausible options.

## Step Order (Mandatory)

1. Confirm the repository, environment, and module boundary in scope.
2. Locate the Terraform file or smallest file set that likely contains the
   change.
3. Identify the exact change needed and keep it as narrow as possible.
4. State whether any ambiguity remains about file choice or environment.
5. State the minimum required verification and Git handoff steps.
6. Wait for approval or hand off to implementation; do not widen the change.

## Scope Rules

- Prefer the smallest file set that can satisfy the task.
- If the task can be done in one file, say so explicitly.
- If multiple files might be affected, explain why before recommending them.
- Never turn a small version or variable update into a module refactor.
- Keep validation minimal unless the user or repo workflow explicitly asks for
  more.

## Evidence Expectations

- Name the directory, module, and environment in scope.
- Name the exact file or candidate files.
- State the intended resource, variable, or setting to change.
- State whether only one file is expected to change.
- State the minimum follow-up validation required.

## Non-Goals

- Do not modify files in this planning step.
- Do not suggest unrelated Terraform cleanup or repo-wide formatting.
- Do not propose `terraform apply` or `destroy`.
- Do not assume a single candidate file when ambiguity remains.
- Do not expand the scope beyond the requested task.

## Output Format

1. FILE DISCOVERY

Identify the Terraform file that likely contains the required change and state:
- directory
- module
- environment

If multiple possible files exist, say so and ask before editing.

2. CHANGE PLAN

Explain exactly what must change, such as:
- update cluster version
- update addon version
- modify variable value
- adjust a resource argument

3. CHANGE SCOPE

State whether the change should affect only one file or a small bounded file
set. Explicitly note if no other files should be modified.

4. TERRAFORM FORMAT

Recommend the minimum required verification:
- `terraform fmt`

Only suggest additional validation when the user explicitly asks or the repo
workflow clearly requires it.

5. GIT PREPARATION

Provide the minimal Git handoff:
- `git checkout -b <branch-name>`
- `git add <files>`
- `git diff`
- `git commit`

Never include a push step unless the user explicitly asks for it.

6. NEXT SAFE STEP

State whether the task is ready for implementation or what ambiguity must be
resolved first.
