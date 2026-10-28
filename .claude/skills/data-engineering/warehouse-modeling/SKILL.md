---
name: warehouse-modeling
description: Implement or refine warehouse models, marts, and semantic-ready tables with explicit grain, testable contracts, and safe incremental behavior.
domain: "data-engineering"
role: execute_build
scope: bounded_task
power: local_repo_mutation
---

# Skill: warehouse-modeling

## Purpose / Use When

Use this skill when:
- building or changing staging, intermediate, mart, or semantic-layer models
- refining model grain, joins, business logic, partitions, or incremental behavior
- adding warehouse tests, documentation, or lineage-facing contracts
- a warehouse change must be implemented with a clear consumer-facing table contract

## When Not to Use

Do not use this skill when:
- the task is raw ingestion or event movement only; use `data-pipeline-implement`
- the task is an application schema migration with no warehouse model surface
- the task is dashboard interpretation or metric storytelling with no warehouse delivery work
- the target model layer, grain, or source tables are unknown

## Input Expectations

Provide:
- the target model, mart, or dataset to change
- the intended grain and primary business keys
- upstream sources and downstream consumers
- freshness, backfill, partition, or incremental expectations
- any existing build, test, or warehouse query command already used by the repo

## Steps / Tasks

1. Run `repo-navigator` to locate the model layer, project config, schema or metadata files, and repo-native warehouse validation commands.
2. State the intended grain before editing. One row per key or time bucket must be explicit.
3. Map upstream sources, business rules, and downstream dependencies so joins, filters, and derived fields are intentional.
4. Keep model logic deterministic. Make partition, watermark, incremental, and backfill behavior explicit instead of implicit.
5. Add or update warehouse tests for uniqueness, not-null, accepted values, relationship integrity, and freshness where the model contract requires them.
6. Preserve column naming and semantic stability for downstream consumers unless the change explicitly includes a migration.
7. Run the repo-native build, test, lint, compile, or query path that proves the model locally.
8. Finish with `self-check`.

## Output Contract

Return:
- the model layer and grain that changed
- the key business rules or incremental behavior that changed
- the validation path that ran
- any backfill, refresh, or downstream migration note
- residual contract risks for downstream consumers

## Tools / Commands

- `rg` for models, schema metadata, sources, tests, and exposures
- repo-native warehouse build, compile, lint, and test commands such as `dbt build --select <model>` when present
- existing warehouse query or fixture commands already defined by the repo
- `git diff -- <path>`

## Dependencies

- `repo-navigator`
- `data-reconciliation`
- `database-migrations` when upstream persistent tables also change
- `data-pipeline-implement` when source delivery changes are required
- `self-check`

## Example

Add an incremental daily orders mart that has one row per account per day, documents its grain clearly, enforces uniqueness and freshness checks, and stays safe to rebuild after a bounded backfill.
