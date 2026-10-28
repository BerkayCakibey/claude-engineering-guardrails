# Use Cases

Copy only the listed components for the use case you want.
Start small, then add more pieces only if the first set is working for you.

Before copying anything:

- Read [../TIPS.md](../TIPS.md).
- Use [recommended-components.md](./recommended-components.md) if you want role-based picks first.
- Copy only the components you actually expect to use.

## Safe Repo Work

Copy:

- `.claude/skills/meta-catalog/task-dispatcher`
- `.claude/skills/meta-catalog/repo-navigator`
- `.claude/skills/meta-catalog/self-check`

Use when you want a compact, reusable default chain for unfamiliar work.

## Backend Implementation

Copy:

- `.claude/skills/backend-platform/node-implement`
- `.claude/skills/backend-platform/python-code-implementer`
- `.claude/skills/meta-catalog/repo-navigator`
- `.claude/skills/qa-testing/test-strategy-planner`
- `.claude/agents/engineering/developer.md`

Use when you want implementation plus explicit verification without pulling in the full orchestrator.

## Bugfix / Debugging

Copy:

- `.claude/skills/backend-platform/bugfix-root-cause-analyzer`
- `.claude/skills/meta-catalog/repo-navigator`
- `.claude/skills/meta-catalog/self-check`
- `.claude/agents/engineering/debugger.md`

Use when the first need is root cause, not feature delivery.

## Infra / Reliability

Copy:

- `.claude/skills/infra-reliability/ops-task-intake`
- `.claude/skills/infra-reliability/terraform-change-planner`
- `.claude/skills/infra-reliability/aws-sso-preflight`
- `.claude/skills/infra-reliability/kubectl-context-preflight`
- `.claude/agents/infra-reliability/devops-engineer.md`
- `.claude/agents/infra-reliability/terraform-safety-reviewer.md`
- `.claude/commands/ops-task.md`
- `.claude/rules/workflow.md`
- `.claude/rules/terraform.md`
- `.claude/rules/kube-aws-gcp.md`

Use when the task is Terraform, Kubernetes, CI/CD, or general CloudOps work and you want safety checks nearby.

## Security Review

Copy:

- `.claude/skills/security/security-scan`
- `.claude/skills/security/dependency-auditor`
- `.claude/skills/security/auth-session-hardening`
- `.claude/agents/security/security.md`

Use when you need a reusable security lane before adopting or changing components.

## Data / Warehouse Work

Copy:

- `.claude/skills/data-engineering/data-pipeline-implement`
- `.claude/skills/data-engineering/warehouse-modeling`
- `.claude/skills/data-engineering/data-reconciliation`
- `.claude/skills/data-engineering/database-migrations`
- `.claude/agents/data/warehouse-engineer.md`
- `.claude/agents/data/database-reviewer.md`
- `.claude/commands/database-task.md`
- `.claude/rules/database-rules.md`

Use when the work is pipelines, warehouse modeling, reconciliation, or migration safety.

## Incident Response

Copy:

- `.claude/skills/infra-reliability/incident-commander`
- `.claude/skills/infra-reliability/aws-sso-preflight`
- `.claude/skills/infra-reliability/kubectl-context-preflight`
- `.claude/skills/infra-reliability/runbook-generator`
- `.claude/agents/orchestration/incident-commander.md`
- `.claude/agents/infra-reliability/rca-readonly-analyst.md`
- `.claude/rules/kube-aws-gcp.md`

Use when an outage or severe degradation needs one coordinator plus a read-only investigation lane.

## Jira Operations

Copy:

- `.claude/agents/orchestration/jira-ops.md`
- `.claude/skills/meta-catalog/repo-navigator`

Use when you want explicit approval-gated Jira reads and mutations alongside a nearby repo-navigation skill for follow-on engineering work.

## Boundary Notes

### MCP Builder vs MCP Server Builder

- Use `.claude/skills/ai-llm/mcp-builder` when the task is broader MCP server design: protocol study, framework choice, tool design, testing strategy, and eval creation.
- Use `.claude/skills/ai-llm/mcp-server-builder` when the task is implementation-oriented: OpenAPI-to-MCP scaffolding, manifest validation, script-backed generation, and contract hardening.
