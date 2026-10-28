---
name: data-pipeline-implement
description: Implement or harden data pipelines, ETL jobs, and feature-preparation flows with schema discipline, idempotency, and verifiable run paths.
domain: engineering_delivery
role: execute_build
scope: lane_workflow
power: local_repo_mutation
---

# Skill: data-pipeline-implement

## Purpose / Use When

Use this skill when:
- building or changing ETL, ELT, batch, stream, or feature-preparation jobs
- wiring ingestion, transformation, validation, or delivery between systems
- adding backfill, checkpoint, retry, or dead-letter behavior
- the user needs implementation guidance tied to real input and output contracts

## When Not to Use

Do not use this skill when:
- the task is dashboarding or business analysis only
- the task is model training research with no pipeline delivery surface
- the task is infra provisioning only; use the ops or Terraform lane
- the source, sink, or schema contract is unknown and cannot be inferred safely

## Input Expectation

Provide:
- source and sink systems
- schema or record contract
- freshness, latency, or batch window expectations
- backfill and replay requirements
- failure semantics, ownership boundaries, and sample commands if they already exist

## Steps / Tasks

1. Run `repo-navigator` to locate the current pipeline entry points, schemas, fixtures, and repo-native test commands.
2. Map the data flow from source to transform to sink before editing.
3. Make idempotency explicit. Prefer stable keys, checkpoints, replay-safe writes, and bounded retries.
4. Enforce schema and nullability checks at the boundary where data first becomes trusted.
5. Add or update dry-run, fixture, or sample-input coverage so the pipeline can be exercised locally.
6. Add tests for malformed input, partial failures, duplicate delivery, and backfill or replay behavior when those risks exist.
7. Run the repo-native verification path and capture the exact commands and artifacts.
8. Finish with `self-check`.

## Output Contract

Return:
- the source to sink flow that changed
- the idempotency and failure-handling choices
- the verification commands or dry-run path
- backfill or rollback notes
- residual data-integrity risks

## Tools / Commands

- `rg` for job, schema, table, queue, and fixture lookup
- repo-native run, test, and lint commands
- `git diff -- <path>`
- any existing dry-run, replay, or fixture command already defined by the repo

## Dependencies

- `repo-navigator`
- `test-strategy-planner`
- `node-implement` or `python-code-implementer` or `golang-pro`, depending on the repo
- `database-migrations` when table shape changes are in scope
- `self-check`

## Example

Add an incremental warehouse loader that reads event files, validates records against the current schema, writes idempotently by event key, supports a bounded backfill window, and proves the flow with fixture-backed tests.
