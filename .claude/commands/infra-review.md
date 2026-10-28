---
description: Review infrastructure architecture -- AWS, GCP, K8s, Terraform
argument-hint: "[scope or infrastructure component]"
---

# Infrastructure Review

Entry point for infrastructure architecture review.

## Step 1: Explore

Use the Skill tool to invoke repo-navigator:
- skill: repo-navigator
- Prompt: explore infrastructure code related to `$ARGUMENTS`

## Step 2: Architecture review

Use the Agent tool to spawn the cloud-architect agent:
- agent: cloud-architect
- Task: review the infrastructure architecture for `$ARGUMENTS`

The cloud-architect will:
- Review AWS/GCP/K8s architecture patterns
- Apply Well-Architected Framework principles
- Evaluate Terraform module structure
- Identify single points of failure
- Assess cost optimization opportunities
- Review networking and security posture

## Step 3: Terraform safety (if applicable)

If Terraform changes are involved, also spawn:
- agent: terraform-safety-reviewer
- Task: review blast radius and risks of the Terraform changes

## Step 4: Report

Combine findings into:
- Architecture assessment
- Risk classification
- Recommendations
- Cost considerations

## Step 5: Self-check the report

Use the Skill tool to invoke self-check:
- skill: self-check
- Verify account/context evidence, risk classification, cost notes, read-only scope, and actionable recommendations

## Rules

- This is read-only -- no terraform apply, no kubectl apply
- Always verify the correct AWS account/K8s context before running commands
- Classify risks as LOW/MEDIUM/HIGH
