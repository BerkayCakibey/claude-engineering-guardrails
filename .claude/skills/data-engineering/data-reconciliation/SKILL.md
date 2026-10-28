---
name: data-reconciliation
description: Audit and prove source-to-sink parity with row-count, key, checksum, and freshness checks before or after pipeline and warehouse changes.
domain: "data-engineering"
role: review_audit
scope: bounded_task
power: advisory_read_only
---

# Skill: data-reconciliation

## Purpose / Use When

Use this skill when:
- a source system and a sink table disagree and the mismatch must be classified
- a backfill, replay, or cutover needs parity proof before sign-off
- warehouse models or batch jobs changed and correctness must be verified
- the user needs a deterministic mismatch report instead of a vague "data looks off" answer

## When Not to Use

Do not use this skill when:
- the main job is implementing a new ingestion or transform path with no comparison surface yet
- the task is an application schema migration with no source-to-sink parity question
- the task is dashboard interpretation with no identified data lineage boundary
- no trusted source, grain, or comparison window can be established

## Input Expectations

Provide:
- the source and sink systems or tables to compare
- the comparison grain, key, and time window
- any accepted tolerance, freshness lag, or known late-arrival behavior
- existing query, export, fixture, or audit commands
- the business question that depends on reconciliation being correct

## Steps / Tasks

1. Run `repo-navigator` to locate the lineage path, existing audit queries or scripts, and repo-native commands used to inspect the data flow.
2. Define the exact comparison boundary: source, sink, grain, time window, and tolerance.
3. Compare counts, key coverage, duplicates, null rates, freshness, and one deterministic aggregate such as checksums or amount totals when that is safe and meaningful.
4. Separate mismatch classes explicitly: missing rows, duplicate rows, late-arriving rows, transform divergence, schema mismatch, or operational lag.
5. Check whether the mismatch follows a clear boundary such as one batch, one partition, one deployment window, or one source subtype.
6. Produce the smallest repair direction that fits the evidence: replay, backfill, schema correction, transform fix, or acceptance of expected lag.
7. Run any existing repo-native audit or dry-run command that proves the mismatch or parity result.
8. End with a concise reconciliation summary and the next lane to use for repair.

## Output Contract

Return:
- the exact source and sink surfaces compared
- the comparison method and time window
- the mismatch class and magnitude, or a clear parity result
- the most likely repair path
- any evidence gap that prevented a stronger conclusion

## Tools / Commands

- `rg` for audit queries, lineage paths, batch IDs, partitions, and fixtures
- existing read-only query, export, dry-run, or audit commands already defined by the repo
- repo-native comparison scripts or notebook entry points when they already exist
- `git diff -- <path>` only when the task also includes reviewing a recent change set

## Dependencies

- `repo-navigator`
- `warehouse-modeling`
- `data-pipeline-implement`
- `database-migrations`
- `self-check`

## Example

Reconcile an orders API export against a warehouse fact table after a weekend backfill, classify whether the mismatch is missing rows, duplicate rows, or expected lateness, and recommend the smallest safe repair path.
