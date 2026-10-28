---
name: skill-tester
description: Validate active skills against the current catalog governance and routing rules before calling a skill change complete
argument-hint: "[skill path or batch scope]"
disable-model-invocation: false
---

# Skill: skill-tester

## Purpose
Validate active skill changes against the repository's current governance model
and validation checks. Use this skill to test whether a skill is correctly
scoped, structurally aligned, and safe to leave active in the catalog.

## Trigger Conditions
Use this skill when:
- reviewing a changed skill before completion
- checking whether a new or rewritten skill fits the current governance model
- validating a small normalization batch after skill edits
- confirming that routed references, generated indexes, and validator outputs still pass

Use a broader repo review workflow instead when the task is not primarily about
skill quality or catalog governance.

## Authoritative Sources
Treat these files as the source of truth:
- `docs/governance/catalog-governance-summary.md`
- `docs/governance/skills-governance.md`
- `docs/authoring/skill-authoring-checklist.md`

Validation guidance is the execution boundary:

## Validation Guidance

For copied usage, validate the skill by checking that:
- the skill has a clear trigger and purpose
- all referenced files exist in the copied package
- examples, commands, and support files are portable
- no repo-local maintainer paths are required

Repository maintainers may run their own catalog validators separately, but
copied users do not need maintainer-only tooling.

## Step Order (Mandatory)
1. Identify the exact skill or batch boundary being tested.
2. Re-read the relevant governance docs before judging structure.
3. Collect repo evidence: routed references, support surface, and adjacent overlaps.
4. Write or update the evaluation record for every reviewed skill.
5. Run the narrowest validator set that matches the changed surface.
6. If a generated file is stale, regenerate it inside the same batch before re-running validation.
7. Return a verdict that separates structural findings, validation evidence, and residual risk.

## What To Check
- catalog state and active-skill boundary
- operating role, scope breadth, and reuse boundary
- correct skill form for the current governance model
- non-goals, evidence contract, and output contract
- support surface proportionality
- routed references and generated index freshness
- overlap with adjacent skills

## Evidence Expectations
- Quote the exact checks or validator commands that were run.
- Distinguish between structural judgment and command-backed validation.
- Name which phrases or references are validator-sensitive when preserving them matters.
- If a skill was not changed because the correct boundary is still unclear, say so explicitly.

## Non-Goals
- Do not use obsolete tier systems, line-count thresholds, or `engineering/` path conventions.
- Do not score skills by length alone.
- Do not rewrite unrelated skills while testing one batch.
- Do not claim a pass without concrete validation evidence.

## Validation Path
Choose the smallest validation path that fits the batch:

1. For a copied or standalone skill, confirm:
   - trigger and purpose are explicit
   - all referenced files exist in the copied package
   - support files, examples, and commands are portable
   - no repo-local maintainer paths are required

2. For active skills inside a specific repository, run that repository's own
   narrowest validation commands when they exist.

3. If a generated file is stale, regenerate it inside the same batch before
   re-running validation.

4. For meaningful batches or before declaring completion, run the narrowest
   repository-wide check available in that setup.

## Output Format
1. REVIEW SCOPE

State:
- the reviewed skill or batch
- what changed
- why this validator set was chosen

2. EVALUATION RECORDS

For every reviewed skill, provide the normalized evaluation record and skill
evaluation addendum required by the governance docs.

3. VALIDATION EVIDENCE

List each command run and whether it passed or failed.

4. FINDINGS OR VERDICT

Return one of:
- `PASS`
- `PASS WITH WARNINGS`
- `REQUIRES FIXES`

If the result is not a full pass, name the smallest next correction.

5. BATCH STATUS

State:
- files touched
- whether generation was required
- whether the batch is a safe checkpoint

## Safety Notes
- Stop if the next correction would spill into a broader catalog rewrite without a stable intermediate state.
- Stop if a merge, split, or rename boundary is still ambiguous after inspection.
- Prefer the smaller active surface when duplicate local tooling conflicts with repo-native validators.
