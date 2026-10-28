---
name: eks-upgrade-planner
description: Plan a safe Amazon EKS cluster upgrade using Terraform and a team runbook
argument-hint: "[cluster name] [current version] [target version]"
disable-model-invocation: false
---

# Skill: eks-upgrade-planner

## Purpose

Produce a safe Amazon EKS upgrade plan that follows the team runbook when one
is provided, uses a PR plus Atlantis workflow, and never turns planning into
direct execution.

## Trigger Conditions

Use this skill when:
- the task is to plan an Amazon EKS control-plane or add-on upgrade
- Terraform-managed cluster version changes must be prepared for review
- compatibility, prerequisite, or rollout risk needs to be assessed before a PR
- an ops workflow explicitly routes to EKS upgrade planning

If the cluster, repository, or environment is unclear, ask before producing a
plan.

## Input Boundary

The user may provide:
- cluster name
- environment name
- current Kubernetes version
- target Kubernetes version
- Terraform repository or directory
- AWS account or profile context

If the user or repository provides an EKS upgrade runbook, treat it as the
authoritative procedure and reflect its rules directly in the plan. Otherwise
fall back to the AWS EKS documentation and the rules below.

## Step Order (Mandatory)

1. Confirm the target cluster, environment, repository path, and upgrade scope.
2. Check the supported Kubernetes version jump and identify required add-on
   compatibility checks.
3. Build the pre-upgrade checklist from the runbook:
   - correct context
   - AWS access
   - `silver-surfer`
   - default storage class
4. Classify the environment risk and call out any specific upgrade hazards.
5. Summarize the Terraform variables and files that must change.
6. Produce the PR, Atlantis plan, apply order, verification, and monitoring
   plan.
7. Keep the workflow planning-only. Do not cross into direct upgrade
   execution.

## Runbook Rules

- Always keep the workflow as PR plus Atlantis.
- Never recommend `terraform apply` or `terraform destroy` as the direct path.
- Never suggest mutating `kubectl` commands as part of the plan output.
- Include compatibility checks for:
  - VPC CNI
  - CoreDNS
  - kube-proxy
  - EBS CSI driver
- Check whether `worker_ami_filter` also needs to change.
- Call out the Docker Hub rate-limit risk and mirrored-image fallback when the
  environment size makes it relevant.

## Evidence Expectations

- State the cluster, environment, account context, and current-to-target
  version path explicitly.
- State the prerequisite checks that must happen before the PR is opened.
- State the Terraform variables or files expected to change.
- State the verification commands and monitoring window needed after rollout.
- Call out any missing information instead of inventing addon versions or repo
  paths.

## Non-Goals

- Do not execute the upgrade.
- Do not propose a direct `terraform apply` workflow.
- Do not skip the runbook or replace it with generic EKS guidance.
- Do not assume addon compatibility without checking the target version path.
- Do not treat a plan as complete when the repository location is still unknown.

## Output Format

1. CLUSTER DISCOVERY

State the cluster, environment, Terraform location, AWS account context, and
known node-group or add-on surface.

2. UPGRADE COMPATIBILITY CHECK

State the supported version path and the addon compatibility work that must be
confirmed.

3. PRE-UPGRADE CHECKLIST

State the prerequisite checks required before a PR is opened.

4. RISK CLASSIFICATION

Classify the environment risk and highlight the main upgrade hazards.

5. IMPLEMENTATION PLAN

Provide the ordered PR plus Atlantis workflow only.

6. TERRAFORM CHANGE SUMMARY

State the variables, files, or filters expected to change.

7. VERIFICATION AND MONITORING

State the post-upgrade verification commands and monitoring period.

## References

- AWS EKS cluster upgrade documentation: https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html
- AWS EKS add-on compatibility documentation for VPC CNI, CoreDNS, and kube-proxy
