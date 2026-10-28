---
name: product-slice-delivery
description: Ship thin end-to-end product slices with explicit user outcome, instrumentation, verification, and controlled rollout boundaries.
domain: engineering_delivery
role: execute_build
scope: lane_workflow
power: local_repo_mutation
---

# Skill: product-slice-delivery

## Purpose / Use When

Use this skill when:
- shipping a thin vertical feature slice across UI, service, data, and instrumentation surfaces
- the task must stay outcome-focused instead of expanding into a broad refactor
- the request includes user-facing acceptance criteria, rollout constraints, or measurement needs

## When Not to Use

Do not use this skill when:
- the task is roadmap or discovery work only; use the planning or business lanes
- the work is isolated to one narrow backend or frontend file with no product-surface impact
- the acceptance criteria are missing and cannot be inferred safely
- the request is a broad redesign rather than a thin deliverable slice

## Input Expectation

Provide:
- the user outcome or workflow being improved
- acceptance criteria and non-goals
- affected surfaces such as UI, API, storage, jobs, or analytics
- rollout or risk constraints
- known test paths and success metrics, if they exist

## Steps / Tasks

1. Run `repo-navigator` to map the end-to-end flow touched by the request.
2. Define the slice boundary and write down the explicit non-goals before editing.
3. Confirm the minimum contract changes across UI, API, storage, and analytics.
4. Implement the smallest end-to-end path that satisfies the acceptance criteria.
5. Add or update instrumentation when the user outcome depends on adoption, errors, or conversion.
6. Run the strongest relevant verification set: repo-native tests, browser evidence, and any feature-specific smoke path.
7. Call out rollout, migration, or follow-up items that are required for safe adoption.
8. Finish with `self-check`.

## Output Contract

Return:
- the user-facing slice that was delivered
- the contracts and surfaces that changed
- instrumentation or measurement coverage
- the verification path that ran
- rollout notes and residual risks

## Tools / Commands

- `rg` for route, handler, state, analytics, and schema lookup
- repo-native lint, type, test, and build commands
- `git diff -- <path>`

## Dependencies

- `repo-navigator`
- `node-implement` or the repo-native implementation skill for the language in use
- `browser-audit`
- `self-check`

## Example

Ship a self-serve settings slice that adds the UI control, validates and persists the preference, emits the existing analytics event shape, and proves the happy path with browser and repo-native test evidence.
