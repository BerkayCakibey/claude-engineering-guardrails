---
paths:
  - "**/*.tf"
  - "**/*.tfvars"
---

# Terraform policy

## Validation policy

- Allowed validation steps: terraform fmt, terraform validate, terraform plan
- Prefer the smallest useful validation step first
- If terraform plan output is very large, prefer saving the plan and reviewing a summary instead of pasting the full output into the conversation
- Recommended pattern for large plans:
  - terraform plan -out=tfplan
  - terraform show -no-color tfplan > plan.txt
  - review only the summary or the relevant changed resources
- Avoid sending extremely large plan outputs directly when a concise summary is sufficient

## Change policy

- Prefer the smallest possible change
- Update only the exact values needed for the task
- If multiple files may match, ask before changing
- Never expand the task scope on your own

## State management

- Never modify state files directly (`terraform.tfstate`)
- Use `terraform state mv` for resource renames, not manual edits
- Use `terraform import` for importing existing resources
- Always back up state before any state operation
- Lock state files in remote backends (S3 + DynamoDB, etc.)

## Module organization

- Use modules for reusable components (VPC, security groups, IAM roles)
- Keep modules small and focused — one responsibility per module
- Use `locals` to compute values, not complex expressions in resource arguments
- Use `variables` with type constraints and descriptions for all configurable values
- Use `outputs` to expose only what consumers need

## Variable and output conventions

- Every variable must have: `type`, `description`, and `default` (or be required)
- Use `object` types for complex configurations, not multiple flat variables
- Name outputs descriptively: `vpc_id`, `bucket_arn`, not `id` or `arn`
- Mark sensitive outputs with `sensitive = true`
- Validate variable values with `validation` blocks where possible

## Provider and backend configuration

- Pin provider versions with `>=` ranges, not `~>` (allows minor/patch updates)
- Use remote backends (S3, GCS, etc.) — never local state in production
- Configure provider blocks in a separate `providers.tf` file
- Use `required_providers` with version constraints in every module

## Resource naming

- Use `snake_case` for resource names: `aws_s3_bucket.app_data`
- Include environment and component in resource names: `app_data_{env}`
- Use `Name` tag consistently across all resources
- Prefix all resources with project/environment identifier

## Risk policy

Treat these as high risk and require explicit user confirmation before editing:

- IAM changes (policies, roles, trust relationships)
- Networking changes (security groups, NACLs, route tables, VPC peering)
- Public exposure changes (S3 bucket policies, load balancers, API gateways)
- Database changes (RDS parameter groups, schema migrations, replica promotion)
- Production environment changes (any resource with `prod` in the name or tags)

## Deployment policy

- Never run terraform apply or terraform destroy
- Assume PR + Atlantis workflow
- Always include a plan output in the PR description
- Tag infrastructure changes with the PR number

## Security policy

- Never hardcode secrets, API keys, or passwords in `.tf` files
- Use `aws_ssm_parameter` or `aws_secretsmanager_secret` for sensitive values
- Mark sensitive variables with `sensitive = true`
- Enable encryption at rest for all storage resources (S3, EBS, RDS)
- Enable access logging for S3 buckets and CloudTrail

## Effort protocol

At the start of every task:

```
EFFORT: low | medium | high
CHAIN: none | minimal | full
REASON: one line
```

- **low**: read-only inspection, state analysis, plan review → no skills
- **medium**: single-resource update, variable change, tag update → terraform-change-planner + self-check
- **high**: multi-resource changes, module creation/rewrite → terraform-change-planner + self-check + code-reviewer

## Self-check after changes

1. Run `terraform fmt -check` — formatting must pass.
2. Run `terraform validate` — validation must pass.
3. Run `terraform plan` — verify expected changes only.
4. Check for drifted resources with `terraform plan -detailed-exitcode`.
5. Verify no secrets in output or state.