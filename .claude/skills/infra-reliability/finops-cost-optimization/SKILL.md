---
name: finops-cost-optimization
description: Audit infrastructure spend, unit-cost regressions, and waste drivers, then produce a prioritized optimization plan with verification and rollback awareness.
domain: infra-reliability
role: review_audit
scope: lane_workflow
power: advisory_read_only
---

# Skill: finops-cost-optimization

## Purpose / Use When

Use this skill when:
- the task is cloud spend review, FinOps triage, or infrastructure cost optimization
- a service, environment, or account shows a cost spike and the driver must be identified
- unit-cost, egress, storage, retention, or rightsizing decisions need evidence before action
- the user needs a ranked optimization plan instead of generic cost-saving advice

## When Not to Use

Do not use this skill when:
- the task is pricing, runway, CAC, LTV, or SaaS business modeling
- the task is cloud topology or platform selection with no spend evidence; use `cloud-architect`
- the task is only performance measurement with no cost question
- the billing window, service boundary, or available spend evidence cannot be identified safely

## Input Expectations

Provide:
- the cloud or platform scope in review
- the billing window or period being compared
- the affected service, environment, account, or workload tags
- available billing, usage, or observability evidence
- constraints such as SLOs, compliance, recovery posture, or purchase commitments

## Steps / Tasks

1. Define the exact review boundary: account, project, cluster, service, and billing window.
2. Separate baseline spend from the reported change. Distinguish steady-state commitments from burst, growth, or waste.
3. Attribute spend to concrete drivers such as compute family, replica floor, log volume, data transfer, storage retention, warehouse scan cost, or idle resources.
4. Correlate cost movement with recent deploys, traffic shifts, retention changes, autoscaling changes, backfills, or region and architecture changes.
5. Identify the smallest reversible optimizations first: remove idle resources, tighten retention, reduce overprovisioned capacity, eliminate wasteful egress, or batch high-frequency work.
6. Evaluate medium-term levers next: right-sizing, storage tiering, schedule-based scaling, reservation or savings-plan fit, and workload placement changes.
7. Reject any action that hides risk. Make performance headroom, reliability impact, recovery impact, and lock-in tradeoffs explicit.
8. Produce a ranked plan with savings bands, validation metrics, owner assumptions, and rollback triggers.

## Output Contract

Return:
- current spend shape and the top cost drivers
- the suspected cause of any spike or regression
- a prioritized action list with expected savings bands
- validation checks required after each action
- deferred actions and the reason they were not recommended now

## Tools / Commands

- billing or usage exports already available in the target environment
- `aws ce get-cost-and-usage`, `aws ce get-dimension-values`, or provider equivalents when available
- `kubectl top`, warehouse usage views, log-volume dashboards, and existing observability reports
- `rg` for retention settings, replica counts, log verbosity, backfill cadence, and known cost knobs in repo code or infra config
- deploy logs, change history, or `git diff` to correlate spend shifts with recent rollout activity

## Dependencies

- `cloud-architect` for topology redesign or platform-level tradeoff decisions
- `sre-engineer` when cost actions could affect SLOs, alerting, or capacity safety
- `observability-designer` when usage, saturation, or burn visibility is too weak to act safely
- `repo-navigator` when repo-local cost controls or retention settings must be found first

## Example

Review a 30-day cost increase on an event-processing system, trace the growth to cross-AZ transfer, verbose log retention, and oversized workers, then deliver a ranked plan that reduces spend without violating latency or recovery requirements.
