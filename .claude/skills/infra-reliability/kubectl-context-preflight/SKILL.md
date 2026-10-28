---
name: kubectl-context-preflight
description: Verify the correct Kubernetes context before running kubectl commands
argument-hint: "[customer] [environment] [cluster]"
disable-model-invocation: false
---

# Skill: kubectl-context-preflight

## Purpose
Verify the correct Kubernetes context before any `kubectl` investigation or
operational command is suggested. Use this guardrail to prevent work against
the wrong cluster or environment.

## Trigger Conditions
Use this skill when:
- the task involves `kubectl`, Kubernetes debugging, EKS work, or cluster checks
- a cluster, customer, or environment must be confirmed before continuing
- an ops workflow just completed AWS identity preflight and needs cluster confirmation

If the intended cluster or environment is unclear, ask before recommending any
context switch.

## Input Boundary
The user may provide:
- customer
- environment
- expected cluster name
- expected context name

Prefer explicit cluster or context names over fuzzy similarity matching.

## Step Order (Mandatory)
1. Identify the intended customer, environment, and cluster or context.
2. List the available contexts before suggesting a switch.
3. Require an exact-match confirmation for the intended context.
4. Suggest a context switch only after the target is explicit.
5. Recommend read-only verification commands after the switch.

## Context Discovery And Switch Rules
Preferred discovery command:

```bash
kubectx
```

Fallback discovery command:

```bash
kubectl config get-contexts
```

If the correct context is known, switch explicitly with one of:

```bash
kubectx <context-name>
kubectl config use-context <context-name>
```

Do not assume that similar-looking names are safe matches.

## Evidence Expectations
- State the intended customer, environment, and cluster or context name.
- Name the context discovery command to run first.
- Name the exact switch command only when the target context is explicit.
- Recommend read-only verification such as:
  - `kubectl config current-context`
  - `kubectl get nodes`
  - `kubectl get ns`

## Non-Goals
- Do not assume the current context is already correct.
- Do not suggest mutating `kubectl` operations from this preflight.
- Do not rely on partial name matches for cluster confirmation.
- Do not downplay production context risk.

## Output Format
1. TARGET CONTEXT IDENTIFICATION

State:
- customer
- environment
- expected cluster or context

2. CONTEXT DISCOVERY

Provide the discovery command to list available contexts.

3. CONTEXT CONFIRMATION

State what exact match must be confirmed before switching.

4. SAFE CONTEXT SWITCH

Provide the explicit context switch command only when the target is known.

5. SAFE VERIFICATION

Provide read-only commands to confirm the active context after switching.
