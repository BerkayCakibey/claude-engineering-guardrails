# Recommended Components

Start with a small set. This guide is role-based. For scenario-based picks, use
[use-cases.md](./use-cases.md). For operating principles before you install too
much globally, read [../TIPS.md](../TIPS.md).

## Cloud / DevOps Engineers

### Start With

- Skills: `.claude/skills/infra-reliability/ops-task-intake`, `.claude/skills/infra-reliability/terraform-change-planner`, `.claude/skills/infra-reliability/aws-sso-preflight`, `.claude/skills/infra-reliability/kubectl-context-preflight`, `.claude/skills/infra-reliability/docker-patterns`
- Agents: `.claude/agents/infra-reliability/devops-engineer.md`, `.claude/agents/infra-reliability/terraform-safety-reviewer.md`, `.claude/agents/architecture/cloud-architect.md`
- Optional commands/rules/hooks: `.claude/commands/ops-task.md`, `.claude/rules/workflow.md`, `.claude/rules/terraform.md`, `.claude/rules/kube-aws-gcp.md`, `.claude/hooks/pretooluse-guard.sh`

### Why

This set covers safe CloudOps intake, Terraform planning, AWS and Kubernetes
preflight checks, and one focused execution lane without forcing you into the
broader orchestration surface.

### Avoid Initially

- `.claude/agents/orchestration/team-lead.md` if you only need infra work
- `.claude/skills/infra-reliability/eks-upgrade-planner` unless you are actively planning an EKS upgrade
- `.claude/skills/infra-reliability/incident-commander` unless you are handling incident workflows

## SRE / Incident Response

### Start With

- Skills: `.claude/skills/infra-reliability/incident-commander`, `.claude/skills/infra-reliability/observability-designer`, `.claude/skills/infra-reliability/runbook-generator`, `.claude/skills/infra-reliability/aws-sso-preflight`, `.claude/skills/infra-reliability/kubectl-context-preflight`
- Agents: `.claude/agents/orchestration/incident-commander.md`, `.claude/agents/infra-reliability/rca-readonly-analyst.md`, `.claude/agents/infra-reliability/sre-engineer.md`
- Optional commands/rules/hooks: `.claude/rules/workflow.md`, `.claude/rules/kube-aws-gcp.md`, `.claude/hooks/notify-bell.sh`

### Why

This set gives you one orchestration lane for incidents, one read-only RCA lane,
and the core runbook and observability components needed for response and
follow-up without installing broad product or business surfaces.

### Avoid Initially

- `.claude/agents/orchestration/team-lead.md` during live incidents
- `.claude/skills/infra-reliability/ci-cd-pipeline-builder` unless CI/CD work is the real task
- `.claude/skills/meta-catalog/office-hours` because it is unrelated to response work

## Security Engineers

### Start With

- Skills: `.claude/skills/security/security-scan`, `.claude/skills/security/dependency-auditor`, `.claude/skills/security/auth-session-hardening`, `.claude/skills/security/sast-orchestrator`, `.claude/skills/security/approval-path-security`
- Agents: `.claude/agents/security/security.md`, `.claude/agents/security/repo-security-reviewer.md`
- Optional commands/rules/hooks: `.claude/commands/security-review.md`, `.claude/hooks/pretooluse-guard.sh`, `.claude/hooks/read-injection-scanner.sh`

### Why

This set covers practical repository security review, auth hardening, dependency
checks, and controlled SAST routing without requiring you to install every
specialized vulnerability lane up front.

### Avoid Initially

- The specialized `sast-*` skills in `.claude/skills/security/` until you know which lane you actually need
- `.claude/agents/orchestration/team-lead.md` if security review is the only job
- `.claude/skills/meta-catalog/self-improving-agent` because it expands scope instead of tightening it

## Software Engineers

### Start With

- Skills: `.claude/skills/meta-catalog/repo-navigator`, `.claude/skills/meta-catalog/task-dispatcher`, `.claude/skills/backend-platform/node-implement`, `.claude/skills/backend-platform/python-code-implementer`, `.claude/skills/qa-testing/test-strategy-planner`, `.claude/skills/meta-catalog/self-check`
- Agents: `.claude/agents/engineering/developer.md`, `.claude/agents/engineering/debugger.md`, `.claude/agents/qa/tester.md`
- Optional commands/rules/hooks: `.claude/commands/node-task.md`, `.claude/commands/python-task.md`, `.claude/commands/bugfix.md`, `.claude/rules/nodejs-dev-workflow.md`, `.claude/rules/python-dev-workflow.md`

### Why

This set gives most engineers a compact default chain for implementation,
debugging, test planning, and final verification without forcing every project
through the broad orchestrator.

### Avoid Initially

- `.claude/agents/orchestration/team-lead.md` if direct execution is enough
- `.claude/skills/backend-platform/tech-debt-tracker` unless debt inventory is the actual goal
- `.claude/skills/meta-catalog/git-pr-packager` if you do not want PR packaging in your active setup

## Data Engineers

### Start With

- Skills: `.claude/skills/data-engineering/data-pipeline-implement`, `.claude/skills/data-engineering/warehouse-modeling`, `.claude/skills/data-engineering/data-reconciliation`, `.claude/skills/data-engineering/database-migrations`, `.claude/skills/data-engineering/postgres-patterns`
- Agents: `.claude/agents/data/data-ml-engineer.md`, `.claude/agents/data/warehouse-engineer.md`, `.claude/agents/data/database-reviewer.md`
- Optional commands/rules/hooks: `.claude/commands/database-task.md`, `.claude/rules/database-rules.md`, `.claude/hooks/pretooluse-guard.sh`

### Why

This set gives you delivery, reconciliation, migration, and warehouse modeling
coverage with one execution lane and one read-only reviewer for data-safety
checks.

### Avoid Initially

- `.claude/agents/orchestration/team-lead.md` if you are staying inside data work
- `.claude/skills/backend-platform/product-slice-delivery` unless the task spans UI and API as well
- `.claude/skills/meta-catalog/office-hours` because it is not a data-delivery component

## AI / Claude Code Power Users

### Start With

- Skills: `.claude/skills/meta-catalog/claude-code-concepts`, `.claude/skills/meta-catalog/selective-install`, `.claude/skills/meta-catalog/context-budget`, `.claude/skills/meta-catalog/repo-navigator`, `.claude/skills/meta-catalog/self-check`, `.claude/skills/ai-llm/harness-optimization`
- Agents: `.claude/agents/ai-platform/harness-optimizer.md`, `.claude/agents/ai-platform/docs-lookup.md`, `.claude/agents/ai-platform/plugin-validator.md`
- Optional commands/rules/hooks: `.claude/hooks/pretooluse-guard.sh`, `.claude/hooks/read-injection-scanner.sh`, `.claude/hooks/write-guard.sh`

### Why

This set helps advanced users keep their Claude setup lean, inspect context
load, understand component mechanics, and add guardrails before they start
customizing heavily.

### Avoid Initially

- `.claude/skills/meta-catalog/skill-creator` unless you are actively authoring new catalog items elsewhere
- `.claude/skills/meta-catalog/self-improving-agent` unless you really want knowledge-workflow machinery
- `.claude/skills/ai-llm/agent-workflow-designer` unless multi-agent design is your primary task

## Independent Vibe Coders

### Start With

- Skills: `.claude/skills/meta-catalog/repo-navigator`, `.claude/skills/backend-platform/product-slice-delivery`, `.claude/skills/qa-testing/test-strategy-planner`, `.claude/skills/qa-testing/browser-audit`, `.claude/skills/meta-catalog/self-check`
- Agents: `.claude/agents/engineering/developer.md`, `.claude/agents/engineering/debugger.md`
- Optional commands/rules/hooks: `.claude/commands/node-task.md`, `.claude/commands/python-task.md`, `.claude/commands/bugfix.md`, `.claude/hooks/notify-bell.sh`

### Why

This is a small, high-leverage starter set for solo builders who want coding,
debugging, browser checks, and a final verification pass without installing the
full catalog.

### Avoid Initially

- `.claude/agents/orchestration/team-lead.md` because it adds breadth and context cost quickly
- `.claude/skills/meta-catalog/knowledge-ops` unless you already have enough volume to justify memory workflows
