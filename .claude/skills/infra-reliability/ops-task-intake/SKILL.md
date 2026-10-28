---
name: ops-task-intake
description: Turn a CloudOps task and optional runbook into a safe execution plan
argument-hint: "[task name]"
disable-model-invocation: false
---

# Skill: ops-task-intake

## Purpose
Turn a CloudOps task and any supporting runbook into a safe execution plan
before any modification begins. Use this skill to clarify scope, classify risk,
and prepare the minimum correct preconditions for infrastructure work.

## Trigger Conditions

Use this skill when:
- a CloudOps task needs scoping before changes are made
- the environment, platform, or affected component must be confirmed first
- the task may involve AWS, Kubernetes, Terraform, networking, IAM, or other
  operational risk surfaces
- a runbook exists and should guide the execution plan

If the environment or account context is unclear, ask before planning further.

## Input Boundary

The user may provide:
- task description
- optional runbook or documentation
- repository or directory context
- environment
- cloud platform
- affected component or module

Do not assume production, account, or cluster context unless the user or repo
evidence confirms it.

## Step Order (Mandatory)

1. Identify the repository, directory, or system boundary involved.
2. Confirm the target environment, platform, and affected component.
3. Classify the task risk as `LOW`, `MEDIUM`, or `HIGH`.
4. List only the relevant preconditions needed before any change.
5. Produce a short execution plan that stays inside the requested scope.
6. Produce the minimum relevant verification plan.
7. Hand off to the next bounded skill when appropriate, such as
   `terraform-change-planner`.

## Risk Classification Rules

- `LOW`
  - read-only investigation
  - non-production planning
  - low-blast-radius documentation work
- `MEDIUM`
  - controlled infrastructure change with limited impact
  - single-resource Terraform update
  - bounded environment-specific operational task
- `HIGH`
  - production work
  - IAM, networking, security-exposure, database, or cluster-upgrade work
  - anything with unclear account or environment boundaries

If risk is `HIGH`, make the uncertainty explicit and keep the plan narrower.

## Evidence Expectations

- State the repository or directory in scope.
- State the target environment and platform.
- State the affected component, module, or service.
- State the chosen risk level and why it applies.
- State only the preconditions and verification steps that are actually relevant.

## Non-Goals

- Do not modify code or infrastructure in this intake step.
- Do not propose `terraform apply`, `destroy`, or live environment mutation.
- Do not expand beyond the requested task.
- Do not include secrets or credential values.
- Do not recommend irrelevant verification or broad repo-wide cleanup.

## Output Format

1. SCOPE DISCOVERY

State:
- repository or directory
- target environment
- target platform
- affected component or module

2. RISK CLASSIFICATION

State `LOW`, `MEDIUM`, or `HIGH` and the reason for that classification.

3. PRECONDITIONS CHECKLIST

List only the relevant preconditions, such as:
- AWS SSO login
- correct AWS profile
- kubectl context
- gcloud project
- runbook review

4. EXECUTION PLAN

Provide the short, ordered plan. Keep it bounded to the requested task.

5. VERIFICATION PLAN

Recommend only the relevant verification. For Terraform planning tasks, the
minimum required verification is `terraform fmt` unless the user asks for more.

6. NEXT SAFE STEP

State the next bounded skill or action, or state what ambiguity must be
resolved before continuing.
