---
description: Start a CloudOps task — Terraform change, EKS upgrade, or Kubernetes investigation
argument-hint: "[task description]"
---

# Ops Task

Entry point for all CloudOps work — Terraform changes, EKS upgrades, Kubernetes debugging, and AWS investigations.

## Step 1: Route the task

Use the Skill tool to invoke task-dispatcher:
- skill: task-dispatcher
- Pass the full task description from the user argument (`$ARGUMENTS`)

Wait for task-dispatcher to classify the task and define the skill chain.

## Step 2: Follow the skill chain

### Terraform change

1. Invoke `aws-sso-preflight` — verify correct AWS account and profile
2. Invoke `ops-task-intake` — scope and risk classification
3. Invoke `terraform-change-planner` — locate file, plan minimal change, wait for approval

### EKS cluster upgrade

1. Invoke `aws-sso-preflight`
2. Invoke `kubectl-context-preflight` — verify correct cluster context
3. Invoke `eks-upgrade-planner` — compatibility check and upgrade plan

### Kubernetes debugging / incident investigation

1. Invoke `aws-sso-preflight`
2. Invoke `kubectl-context-preflight`
3. Invoke `rca-readonly-analyst` — read-only investigation

### AWS read-only investigation

1. Invoke `aws-sso-preflight`
2. Invoke `rca-readonly-analyst`

## Rules

- Never run terraform apply or terraform destroy
- Never run kubectl apply, delete, patch, or exec
- Always verify cloud context (account, profile, cluster) before any command
- Stop and ask the user before expanding scope
- High-risk changes (IAM, networking, production) require explicit user confirmation
