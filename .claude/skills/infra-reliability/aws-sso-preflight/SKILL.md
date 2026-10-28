---
name: aws-sso-preflight
description: Prepare AWS CLI and kubectl access safely by checking SSO login, AWS profile, and target environment
argument-hint: "[customer] [environment]"
disable-model-invocation: false
---

# Skill: aws-sso-preflight

## Purpose
Verify the correct AWS SSO session, profile, and target environment before any
AWS CLI, Terraform, or EKS-related work begins. Use this preflight to prevent
wrong-account or wrong-environment operations.

## Trigger Conditions
Use this skill when:
- the task involves AWS CLI, Terraform, EKS, or AWS-backed Kubernetes work
- the customer, environment, or account must be confirmed before proceeding
- an ops workflow needs AWS identity verification before the next step

If the customer or environment is unclear, ask before recommending commands.

## Input Boundary
The user may provide:
- customer name
- environment name
- expected AWS profile
- whether EKS access is expected
- terminal type when not using the default shell

Use the SSO session name defined in the user's `.aws/config` (shown below as
`my-sso-session`) unless the user or repo evidence explicitly says otherwise.

## Step Order (Mandatory)
1. Identify the target customer, environment, and whether EKS access is in scope.
2. Inspect the AWS profile naming surface and find the matching profile in
   `.aws/config` or the user's known profile list.
3. Confirm whether the SSO session is missing or expired.
4. Prepare the correct profile activation command.
5. Recommend only safe verification commands for identity and cluster visibility.
6. If Kubernetes work follows, hand off to `kubectl-context-preflight`.

## Profile And Session Rules
- Expected profile names usually resemble `customer-environment`, such as:
  - `acme-dev`
  - `acme-stg`
  - `acme-prd`
- Never guess between multiple plausible profiles.
- Default shell syntax is bash / WSL / Linux / macOS:

```bash
export AWS_PROFILE="<profile-name>"
```

- Use PowerShell syntax only when the user confirms they are in a PowerShell session:

```powershell
$env:AWS_PROFILE="<profile-name>"
```

- Default login command:

```bash
aws sso login --sso-session my-sso-session
```

## Evidence Expectations
- State the confirmed or requested customer and environment.
- Name the intended AWS profile explicitly.
- State whether EKS access is expected.
- Recommend a read-only verification command such as:
  - `aws sts get-caller-identity`
  - `aws eks list-clusters`
- Call out unresolved ambiguity instead of choosing a profile implicitly.

## Non-Goals
- Do not suggest mutating AWS commands in this preflight step.
- Do not assume the active profile is already correct.
- Do not default to PowerShell syntax unless the user confirmed PowerShell.
- Do not skip session refresh when the SSO state is uncertain.
- Do not proceed into Kubernetes operations without a separate context check.

## Output Format
1. TARGET IDENTIFICATION

State:
- customer
- environment
- expected AWS profile
- whether EKS access is expected

2. PROFILE DISCOVERY

Describe how to locate or confirm the matching AWS profile and list any
ambiguity that must be resolved first.

3. SSO SESSION CHECK

State whether `aws sso login --sso-session my-sso-session` should be run or rerun
before continuing.

4. PROFILE ACTIVATION

Provide the exact `AWS_PROFILE` activation command for the user's shell.

5. SAFE VERIFICATION

Provide only read-only identity or cluster-visibility checks.

6. NEXT SAFE STEP

State whether the user can continue, or whether `kubectl-context-preflight` is
required next.
