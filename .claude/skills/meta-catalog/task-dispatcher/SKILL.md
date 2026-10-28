---
name: task-dispatcher
description: Identify the correct skill or workflow to handle a user request
argument-hint: "[task description]"
disable-model-invocation: false
---

# Skill: task-dispatcher

## Purpose
Classify a user request, choose the smallest correct skill or agent chain, and
identify the first step. This skill routes work; it does not implement tasks or
modify files.

## Trigger Conditions
Use this skill when:
- the request needs a non-trivial skill chain, agent route, or task-category decision
- the correct workflow depends on language, repo context, risk, or output type
- a narrower standalone skill is not already obviously sufficient

Skip this skill when the request matches the `NO-SKILL TASKS` section or when a
single standalone skill clearly owns the boundary.

## Step Order (Mandatory)
1. Decide whether the dispatcher should be skipped.
2. Estimate effort: `low`, `medium`, or `high`.
3. Match the request to the closest task category.
4. Start from that category's `CORE` chain or direct-agent rule.
5. Add only the `CONDITIONAL` skills whose triggers are actually met.
6. Apply the always-on user rules and exclusions.
7. Return the route using the required output format.

## Routing Inputs
- user goal and requested output
- repo state, affected language or platform, and whether code already exists
- explicit risk factors such as auth, secrets, infra, browser/runtime, or multi-file scope
- whether the user asked for direct execution, a review, or a narrow standalone skill

## Routing Rules
- Prefer installed skills over freeform execution.
- If the request is ambiguous, ask before routing.
- Build the chain from `CORE` plus applicable `CONDITIONAL` skills. Never include the full list blindly.
- Read the decision criteria for each conditional skill before including it.

## Effort-Based Trim
- low (research, config diff, Q&A): no skills needed, skip dispatcher entirely.
- medium (single-file fix, small feature): `CORE` only, no conditional skills unless explicitly triggered.
- high (multi-file feature, new module): `CORE` plus the conditional skills whose triggers are met.

## Non-Goals
- Do not implement the task.
- Do not modify files.
- Do not include the full catalog blindly.
- Do not override explicit repo or user rules such as the no-`git-pr-packager` policy.

## USER RULES (always enforced)
- NEVER include git-pr-packager — user handles push/PR themselves.
- NEVER route to changelog or release-note automation in this repo unless the user explicitly changes the no-changelog policy.

---

TASK CATEGORIES

---

Python — new project

CORE:
1. repo-navigator
2. python-project-planner
3. python-implementation-planner (mode: new-project)
4. python-dev-preflight
5. python-code-implementer
6. self-check

CONDITIONAL:
- test-strategy-planner → IF project needs tests (most new projects do)
- tdd-guide → IF user explicitly requests TDD approach
- python-quality-review → IF high effort AND multi-module project
- python-security-review → IF project handles auth, secrets, user input, or network
- code-reviewer → IF user explicitly requests review

---

Python — extend existing

CORE:
1. repo-navigator
2. python-implementation-planner (mode: extend-existing)
3. python-code-implementer
4. self-check

CONDITIONAL:
- test-strategy-planner → IF task includes writing tests OR touches untested code
- tdd-guide → IF user explicitly requests TDD
- python-quality-review → IF high effort AND touching 3+ files
- python-security-review → IF change touches auth, input validation, sandbox, docker, or secrets
- code-reviewer → IF user explicitly requests review

---

Python — bug fix

CORE:
1. repo-navigator
2. bugfix-root-cause-analyzer
3. python-code-implementer
4. self-check

CONDITIONAL:
- test-strategy-planner → IF fix reveals missing test coverage for the bug class
- python-security-review → IF bug is security-related (injection, auth bypass, etc.)

---

Code review / technical audit (source code)

CORE:
1. repo-navigator
2. code-reviewer
3. tech-debt-tracker
4. self-check

CONDITIONAL:
- security agent → IF review scope includes security posture
- dependency-auditor → IF review scope includes supply chain / dependencies
- python-quality-review → IF Python-heavy codebase and quality is in scope
- type-design-analyzer → IF API, schema, or type contracts are in scope
- pr-test-analyzer → IF reviewing a change set, tests, or false-green risk
- database-reviewer → IF migrations, queries, data integrity, or Postgres are in scope
- performance-optimizer → IF latency, throughput, memory, or benchmark risk is in scope
- TypeScript/Python/Go/Rust reviewer agents → IF language-specific depth is needed

---

Config / setup audit (rules, skills, agents, memory)

CORE:
1. repo-navigator (map structure across locations)
2. self-check (verify consistency of changes)

No code-reviewer or tech-debt-tracker — these are for source code, not config files.
Audit is manual: cross-reference checks, drift detection, stale content identification.

---

Claude Engineering Guardrails / claude-engineering-guardrails component hardening

CORE:
1. repo-navigator
2. smart-explore
3. context-budget
4. self-check

CONDITIONAL:
- knowledge-ops → IF updating durable docs, catalogs, reports, or reusable repo knowledge
- strategic-compact → IF the thread already has multiple commits, decisions, or deferred work
- skill-development / agent-development / command-development → IF changing skill, agent, or command authoring guidance
- selective-install / harness-optimization → IF install profiles, manifest, component counts, hooks, or publication flow are touched

Rules:
- Keep `CONTRIBUTING`, `CHANGELOG`, GitHub issue templates, PR templates, and release automation out unless the user reverses the policy.
- Update README, generated indexes, manifest, and validation only when counts or catalog-visible behavior change.
- Never push.

---

Memory / context retrieval

CORE:
1. mem-search
2. smart-explore
3. context-budget

CONDITIONAL:
- strategic-compact → IF preparing a handoff, long-session continuation, or post-commit status
- knowledge-ops → IF the result should become reusable repository knowledge
- repo-navigator → IF retrieval is tied to current code or config

Rules:
- Start with search index, then timeline, then selected observations.
- Current repository state overrides remembered state.

---

Product review board / guardrails planning

CORE:
1. office-hours
2. plan-ceo-review
3. plan-eng-review
4. self-check

CONDITIONAL:
- plan-design-review → IF user-facing UI, UX, visual quality, or accessibility is in scope
- plan-devex-review → IF setup, docs, commands, local tooling, or maintainer flow is in scope
- qa / browser-audit / click-path-audit → IF existing web UI needs browser evidence
- benchmark / canary-watch / safety-guard / freeze-scope → IF rollout, performance, or high-risk changes are in scope
- codex-second-opinion → IF the plan is high-risk or user asks for a second opinion

Rules:
- Skip review modes that do not match the actual task.
- Do not use this flow for a small code fix unless product risk is the main question.

---

SAST / vulnerability review

CORE:
1. repo-navigator
2. sast-orchestrator
3. self-check

CONDITIONAL:
- prompt-leak-defense → IF prompt, system instruction, or model-output exposure is in scope
- dependency-auditor → IF supply chain or dependency advisories are in scope
- specialist SAST skills → ONLY IF the trust-boundary map supports the lane

Rules:
- Separate confirmed vulnerabilities from static pattern leads.
- Never output raw secret values.
- Do not run every specialist lane by default.

---

CloudOps — Terraform

CORE:
1. aws-sso-preflight
2. ops-task-intake
3. terraform-change-planner

No conditional skills. Scope is always narrow.

---

CloudOps — EKS upgrade

CORE:
1. aws-sso-preflight
2. kubectl-context-preflight
3. eks-upgrade-planner

---

CloudOps — K8s debug

CORE:
1. aws-sso-preflight
2. kubectl-context-preflight
3. rca-readonly-analyst

---

CloudOps — AWS investigation

CORE:
1. aws-sso-preflight
2. rca-readonly-analyst

---

Go development

CORE:
1. repo-navigator
2. golang-pro
3. self-check

CONDITIONAL:
- test-strategy-planner → IF task includes writing tests
- code-reviewer → IF user explicitly requests review

---

Go debugging

CORE:
1. repo-navigator
2. debugger agent
3. golang-pro
4. self-check

---

Node.js / TypeScript development

CORE:
1. repo-navigator
2. node-implement
3. self-check

CONDITIONAL:
- test-strategy-planner → IF task includes writing tests
- edge-runtime-implement → IF the runtime target is worker, middleware, service worker, or CDN-adjacent handler
- code-reviewer → IF user explicitly requests review

---

Node.js debugging

CORE:
1. repo-navigator
2. debugger agent
3. node-implement
4. self-check

---

Data / ML / pipeline delivery

CORE:
1. repo-navigator
2. data-ml-engineer agent

CONDITIONAL:
- data-pipeline-implement → IF the task is an implementation or hardening change, not just analysis
- database-migrations → IF persistent schema changes are involved
- test-strategy-planner → IF verification is unclear or weak

---

Product slice delivery

CORE:
1. repo-navigator
2. product-engineer agent

CONDITIONAL:
- product-slice-delivery → IF the task crosses UI, API, data, or analytics boundaries
- browser-audit → IF a user-facing flow changed
- test-strategy-planner → IF verification is unclear

---

Security review

CORE:
1. repo-navigator
2. security agent

CONDITIONAL:
- auth-session-hardening → IF the request includes implementation or hardening of login, session, token, or authorization paths
- dependency-auditor → IF dependencies are in scope (not just code review)
- sast-orchestrator → IF code-level vulnerability classes, endpoints, auth boundaries, or multi-language SAST are in scope
- prompt-leak-defense → IF prompts, model instructions, system messages, or extraction risk are in scope

---

CI/CD pipeline

CORE:
1. repo-navigator
2. ci-cd-pipeline-builder
3. devops-engineer agent
4. self-check

---

Architecture / DDD

CORE: repo-navigator + clean-ddd-hexagonal

For infrastructure architecture (AWS/GCP/K8s/Terraform) → cloud-architect agent instead.

---

SRE / Incident response

CORE:
1. aws-sso-preflight
2. sre-engineer agent

CONDITIONAL:
- kubectl-context-preflight → IF K8s is involved
- observability-designer → IF designing new monitoring/alerting
- runbook-generator → IF creating operational runbooks

---

Jira task → delegate to `team-lead` directly. No skill chain here.

---

NO-SKILL TASKS (do not invoke dispatcher)

These tasks need no skill chain — handle directly:
- PR review (read + analyze)
- Git operations (commit, branch, diff)
- File reading / exploration
- Quick Q&A about code
- Tiny config lookups that do not change files
- Tiny memory/status lookups that do not need retrieval planning

---

STANDALONE SKILLS (use one directly for narrow scope)

repo-navigator, self-check, browser-audit, node-implement, webapp-testing,
skill-security-auditor, dependency-auditor, code-reviewer, codebase-onboarding,
api-design-reviewer, api-test-suite-builder, tech-debt-tracker, skill-creator,
skill-tester, incident-commander, mcp-builder, mcp-server-builder,
senior-prompt-engineer, agent-workflow-designer, architecture-decision-records,
mem-search, context-budget, smart-explore, strategic-compact, knowledge-ops,
sast-orchestrator, office-hours, data-pipeline-implement,
auth-session-hardening, edge-runtime-implement, product-slice-delivery

---

## Evidence Expectations
- Base the route on explicit task cues, repo context, language or platform, and stated risk.
- When excluding a plausible skill, say why in `CONDITIONAL` or `EXCLUDED`.
- If the route depends on unresolved ambiguity, ask instead of forcing a category.

OUTPUT FORMAT

```
EFFORT: low | medium | high
TASK CATEGORY: [name]
CORE CHAIN: [ordered list — always runs]
CONDITIONAL: [skill → reason for inclusion] (or "none")
EXCLUDED: [skills skipped and why] (or "none")
START WITH: [first skill] — [reason]
```

DECISION RULES

1. Start with CORE. Only add CONDITIONAL skills whose trigger condition is met.
2. For Python tasks: self-check is mandatory. At least one review skill for high effort.
3. Never skip repo-navigator for tasks involving an existing codebase.
4. tdd-guide only if TDD is explicitly requested.
5. If effort is medium, do not add conditional skills unless the trigger is explicitly present in the request.
6. When in doubt about a conditional skill, leave it out — user can request it.
