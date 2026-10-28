---
description: Delegate a task to the team-lead orchestrator agent
argument-hint: "[task description]"
---

# Team

Delegates the task to the team-lead orchestrator agent.

The team-lead will:
1. Understand the request
2. Create an execution plan (3-5 bullets)
3. Present the plan for your approval
4. On approval: delegate to specialized agents and invoke skills
5. Track progress and handle failures
6. Deliver a final status report

## Invoke

Use the Agent tool to spawn the team-lead agent:
- agent: team-lead
- Task: `$ARGUMENTS`

The team-lead has access to ALL agents and ALL skills. For component-library
work, route through the expanded specialist surface instead of defaulting to a
single generic implementer:

- architecture and code tracing: software-architect, code-explorer
- product delivery: product-engineer
- tests and false-green risk: tester, pr-test-analyzer, silent-failure-hunter
- security and SAST: security, repo-security-reviewer, sast-orchestrator
- data and backend risk: data-ml-engineer, database-reviewer, performance-optimizer
- language depth: typescript-reviewer, python-reviewer, go-reviewer, rust-reviewer
- docs and plugin quality: doc-updater, docs-lookup, plugin-validator, harness-optimizer

## When to use

- Complex multi-step tasks that span multiple domains
- Tasks that require coordination between agents (e.g., Jira + implementation + testing)
- When you want full lifecycle management (plan + implement + review + PR)
- When you are unsure which agent or skill to use

## Skill Chain

The team-lead agent uses **task-dispatcher** internally to route tasks:

1. **task-dispatcher** — analyzes task type and identifies correct skill chain
2. Route to appropriate specialist agent
3. Specialist invokes domain-specific skills
4. **self-check** — validates implementation

For long or context-heavy work, add **mem-search**, **smart-explore**,
**context-budget**, and **strategic-compact** before delegating broad reading.

For ambiguous tasks, team-lead consults task-dispatcher first to identify the right delegation path.
