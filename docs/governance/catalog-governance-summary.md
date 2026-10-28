# Catalog Governance Summary

This document defines the shared governance model for `.claude/skills` and `.claude/agents`.
It is a governance framework, not a runtime prompt format. Runtime files should stay focused on invocation-time instructions. Governance metadata and review decisions should live in review artifacts, inventories, or future manifest files, not be pushed into every prompt file by default.

## Scope

- `.claude/skills/<domain>/*`
- `.claude/agents/<domain>/*`
- Existing validation and manifest scripts that already treat these areas as a curated catalog

## Discovery Summary

### Repository Signals

- `.claude/skills` contains `7` domain directories and `129` active skills at `.claude/skills/<domain>/<skill-name>/SKILL.md`.
- There are currently no staged placeholder skill directories under `.claude/skills`.
- `.claude/agents` contains `8` domain directories and `39` active single-file agents at `.claude/agents/<domain>/<agent-name>.md`. There are no agent placeholders.
- Existing automation should treat categorized `SKILL.md` and `*.md` paths as the active component boundary.
- Existing docs and scripts already distinguish install profiles, active component counts, and routing references.

### Skills: What Actually Exists

Active skills fall into six real document families (family counts below come from the pre-publication catalog snapshot):

1. `compact pattern card`
   Observed: `47`
   Signals: narrow reusable pattern cards with validator-backed headings such as `Do Not Use When`, `Focus Checklist`, `Evidence To Collect`, and `Output Contract`.
2. `compact guardrail`
   Observed: `29`
   Signals: narrow review or audit skills with explicit gates, evidence requirements, and constrained output contracts.
3. `standard workflow`
   Observed: `44`
   Signals: bounded workflows with explicit trigger conditions, mandatory step order, non-goals, and output format.
4. `consulting playbook`
   Observed: `47`
   Signals: advisory research or planning workflows with context prerequisites, discovery questions, decision frameworks, and structured outputs.
5. `workbench or automation`
   Observed: `14`
   Signals: broader script-backed or asset-backed execution surfaces that name entry points, output locations, support assets, and validation paths.
6. `hybrid specialist`
   Observed: `4`
   Signals: routed specialist skills that still combine multiple form traits and need bespoke treatment instead of direct family reduction.

Additional observed facts:

- `52` active skills use `references/`.
- `19` use `scripts/`.
- `7` use `assets/`.
- `5` use `expected_outputs/`.
- `3` use `evals/`.
- No active skill currently vendors `node_modules`; vendoring should still be treated as an exceptional support-depth case if it is ever introduced.
- `38` active skills carry extra frontmatter keys beyond `name` and `description`; the extra keys currently in use are `argument-hint`, `disable-model-invocation`, `command`, and the execution-lane classification keys `domain`, `role`, `scope`, and `power`.
- The current topical taxonomy used by the skill-index generation tooling is useful, but it is maintained outside the skill files and mixes subject matter with functional role.

### Agents: What Actually Exists

Agents are much more uniform than skills, but still split into four meaningful families:

1. `read-only reviewer`
   Observed: `22`
   Signals: `Read, Grep, Glob`, `model: sonnet`, `permissionMode: default`, short review prompts with explicit output formats.
2. `read-only operator`
   Observed: `4`
   Signals: read-only plus `Bash` or connector tools, advisory investigation posture, often operational or systems oriented.
3. `execution specialist`
   Observed: `17`
   Signals: `Edit/Write/Bash/Skill`, longer prompts, domain execution workflows.
4. `orchestrator`
   Observed: `3`
   Signals: `Agent` delegation, broad routing scope, highest breadth and governance burden.

Additional observed facts:

- Agent frontmatter is now explicit on active agents for `model` and `permissionMode`, but connector-heavy tool ordering and body-contract sharpness still need periodic review.
- `jira-ops` is the only active agent whose contract can mutate an external system without local repo write tools, so inventories must not treat `Edit`/`Write` as the only execution signal.
- Tool surface ordering is inconsistent.
- Short read-only reviewer prompts are a healthy pattern in this repo; brevity is often correct for them.
- Several execution/orchestrator agents embed lane knowledge that should usually live in skills or references instead of in the agent body.

## Current Taxonomy Snapshot

Status legend:

- `observed`
  Derived directly from files, scripts, profiles, and generated indexes in this repo.
- `partial`
  The lane exists, but the current catalog is imbalanced, too advisory, or missing a durable execution owner.
- `inferred`
  The weakness is inferred from routing, install profiles, and missing execution surfaces rather than from runtime telemetry.

### Balance Findings

- `backend-platform`: `observed strong` and still the largest engineering skill lane.
- `security`: `observed strong` with deep specialist coverage.
- `data-engineering`: `observed resolved` as a distinct domain, but still a small specialist lane.
- `meta-catalog`: `observed strong`, but intentionally large because catalog mechanics, review-board routing, and memory workflows include uneditable cross-skill references that must stay co-located.
- Agent routing is now explicit for `data`, `qa`, `architecture`, `infra-reliability`, and `orchestration` instead of collapsing those roles into `engineering` or `ai`.

### Domain Gap Table

| Surface | Status | Evidence |
|--------|--------|----------|
| required skill domains | `observed complete` | All `7` required skill domains exist in the live tree. |
| required agent domains | `observed complete` | All `8` required agent domains exist in the live tree. |
| overloaded skill lanes | `partial` | `meta-catalog` remains the largest lane because the `office-hours` review-board cluster, `skill-creator` plus `repo-navigator`, and the `mem-search` cluster contain uneditable relative references. |
| underweight skill lanes | `partial` | `data-engineering` is an intentionally narrow specialist lane with only a few high-specificity assets. |
| overloaded agent lanes | `partial` | `engineering` is still the largest agent lane, but its former data/qa/architecture spillover has been split out. |
| ambiguous boundaries | `partial` | `ai-llm` vs `meta-catalog` still requires periodic review. |

### Capability Gap Table

| Capability | Status | Notes |
|------------|--------|-------|
| execution skills (`run -> output`) | `observed strong` | Backend, data, security, infra, and QA all have concrete execution or review workflows. |
| real-world tools (logs, performance, cost) | `partial` | The catalog has strong browser, observability, and infra coverage, but still relies on a small number of runtime-heavy specialists. |
| reusable workflows | `observed strong` | Routing, implementation, review, QA, and strategy workflows are all first-class lanes. |

### Governance Gap Table

| Area | Status | Notes |
|------|--------|-------|
| agent `model` / `permissionMode` coverage | `observed resolved` | Historical drift is no longer present on active agents. |
| tool ordering consistency | `partial` | Mostly normalized, with connector-heavy exceptions such as Jira surfaces. |
| boundary and output contracts | `partial` | Broad agents and routing docs still need periodic tightening so lane logic stays in skills. |
| cross-skill relative references | `partial` | Several skills reference sibling skill directories by relative path, which constrains future folder moves until the prompt content itself is revised. |
| flat-install path assumptions inside runtime content | `partial` | Some skills still mention flat installed locations such as `.claude/skills/<skill-name>` or `$HOME/.claude/skills/<skill-name>`, which cannot be corrected in this pass because runtime content is out of scope. |

### Current Structural Watchpoints

| Watchpoint | Surface | Reason |
|------|------|-----------|
| `office-hours` review-board cluster | `skills/meta-catalog` | `office-hours`, `plan-ceo-review`, `plan-eng-review`, `plan-design-review`, `plan-devex-review`, and `qa` use uneditable sibling references and must stay co-located. |
| `skill-creator` plus `repo-navigator` | `skills/meta-catalog` | `skill-creator` references `../repo-navigator`, so those two skills must remain siblings until runtime content is updated. |
| `mem-search` cluster | `skills/meta-catalog` | `context-budget`, `knowledge-ops`, and `strategic-compact` reference `mem-search` assets by relative path. |
| `ai-llm` vs `meta-catalog` boundary | `skills` | AI platform mechanics and catalog mechanics are cleaner than before, but some agentic workflow assets still sit near the line. |
| orchestration agents | `agents/orchestration` | Keep delegation and approval rules here rather than leaking them back into domain specialists. |

A balanced-expansion snapshot still exists in maintainer-side tooling outside the public component-library surface.
The removed execution-layer contract artifacts are archived outside the main component-library surface.

### Structural Drift That Governance Must Address

- Placeholder work should not be left as empty skill directories or ambiguous domain entries, because that blurs lifecycle state and active-catalog intent.
- Skill structure is plural by design, but current families do not have one governance model explaining when each form is appropriate.
- A small residual hybrid/imported subset still sits outside the dominant normalized forms and needs explicit manual handling.
- Category assignment currently lives in scripts and docs, not in a reusable governance layer.
- Skills already have validators for frontmatter, compact-card structure, and reference validity, but not for lifecycle state, form fit, support-asset justification, or rewrite triggers.
- Agents now have frontmatter validation, reference validation, and a generated external contract inventory, but they still lack family-specific semantic validation.

## Governance Principles

1. Runtime prompts stay lean.
2. Governance metadata stays external unless a field is needed at invocation time.
3. Category is not role. Role is not scope. Scope is not risk. Risk is not importance.
4. Brevity is a positive trait when scope is narrow and boundaries are explicit.
5. Detail is mandatory when power, branching, or failure cost make omission dangerous.
6. Support assets must be justified by operational complexity, not by style preference.
7. Empty placeholders are lifecycle state, not broken active skills.
8. Review and rewrite decisions must be reproducible from explicit rules.

## Shared Classification Model

Use the following sequence for both skills and agents.

### Step 0: Catalog State

Assign state before any deeper classification.

- `active`
  A real runtime file exists: `SKILL.md` for skills or `*.md` for agents.
- `staged placeholder`
  A reserved path exists, but no active runtime file exists. When such paths exist, they should be treated as lifecycle state rather than malformed active skills.
- `archived/reference`
  Material is intentionally retained outside the active catalog surface.

Do not judge a staged placeholder against active-file schema rules.

### Axis 1: Domain Lane

This answers: what problem space does this component primarily serve?

Allowed primary values depend on the catalog surface.

Skills:

- `backend-platform`
- `qa-testing`
- `infra-reliability`
- `data-engineering`
- `ai-llm`
- `security`
- `meta-catalog`

Agents:

- `engineering`
- `data`
- `qa`
- `architecture`
- `infra-reliability`
- `security`
- `ai-platform`
- `orchestration`

Optional secondary tag:

- `language_framework`

Decision rule:

- Choose the domain implied by the primary user outcome, not by the implementation technique.
- Add `language_framework` only when the component is specialized to a language or framework.

Common mistake:

- Inventing ad hoc buckets such as `patterns`, `review`, or `misc` instead of using one of the allowed lanes. Use `qa-testing` for verification work and `meta-catalog` for catalog mechanics instead of creating new catch-alls.

### Axis 2: Operating Role

This answers: what kind of work does the component perform?

Allowed values:

- `discover_route`
- `plan_design`
- `execute_build`
- `review_audit`
- `synthesize_document`
- `orchestrate_delegate`

Decision rule:

- Pick the single primary action the component is supposed to complete.
- If the file tries to do two primary actions equally, that is a split/realignment signal.

Common mistake:

- Calling a skill "implementation" because it discusses implementation, when its real job is planning or review.

### Axis 3: Scope Breadth

This answers: how much surface should one invocation cover?

Allowed values:

- `narrow_card`
  One decision surface or one sharply bounded check.
- `bounded_task`
  One complete task or one repeatable workflow.
- `lane_workflow`
  A multi-step lane workflow with several sub-decisions.
- `cross_lane_orchestrator`
  Cross-lane routing, delegation, or synthesis.

Decision rule:

- Count how many independent sub-problems can be solved without leaving the component.
- If the component must routinely choose between unrelated tracks, it is broader than `bounded_task`.

Common mistake:

- Using document length as a proxy for breadth.

### Axis 4: Power Surface

This answers: what can the component directly cause?

Allowed values:

- `advisory_read_only`
- `local_repo_mutation`
- `environment_operator`
- `delegating_cross_system`

Decision rule:

- Use frontmatter tools, referenced scripts, and stated workflow, not the topic alone.
- For skills, classify by normal expected execution, not by hypothetical misuse.

Common mistake:

- Marking every security or ops component as high power even when it is review-only.

### Axis 5: Maintenance Importance

This answers: how central is the component to the catalog?

Allowed values:

- `core_backbone`
  Baseline routing or default-profile component.
- `lane_backbone`
  Essential inside one lane or install profile.
- `specialist`
  Valuable but optional or situational.
- `showcase_or_staged`
  Explicitly optional, demonstrative, or not yet active.

Decision rule:

- Use install profiles, routing docs, and dependency chains.
- If other components assume this one exists, it is at least `lane_backbone`.

Common mistake:

- Equating popularity of a topic with backbone status.

### Axis 6: Risk Criticality

This answers: how costly is weakness or ambiguity?

Allowed values:

- `low`
- `medium`
- `high`
- `very_high`

Decision rule:

- Score based on user harm, trust boundary exposure, irreversibility, and catalog dependency.
- Safety guards, routing backbones, external-op surfaces, and orchestrators are usually `high` or `very_high`.

Common mistake:

- Treating long documents as high criticality by default.

### Axis 7: Reuse Class

This answers: how broadly should this component stay reusable?

Allowed values:

- `global_reusable`
- `lane_reusable`
- `contextual_specialist`

Decision rule:

- If the trigger and guidance survive repo changes and customer changes, classify higher.
- If the content only makes sense for a narrow scenario, keep it contextual.

Common mistake:

- Packaging a one-off operating style or niche edge case as a supposedly global component.

## Derived Output: Detail Burden

Do not assign document detail by intuition. Derive it from the axes above.

- `compact`
  Narrow scope, advisory power, and low branching. Brevity is correct.
- `standard`
  Bounded task, moderate branching, or backbone importance. Explicit I/O and output contract required.
- `extended`
  Lane workflow, high criticality, or cross-file reasoning. Edge cases and non-goals required.
- `workbench`
  Script-backed, asset-backed, or environment-touching workflow. Main file must stay slim while references/scripts carry depth.

## Shared Review Workflow

1. Determine catalog state.
2. Inspect the runtime file and nearby support assets.
3. Assign all shared axes.
4. Derive the expected detail burden.
5. In the relevant directory guide, assign the catalog-specific form.
6. Compare the current file against the expected form.
7. Choose one disposition:
   - `aligned`
   - `acceptable_with_fixes`
   - `structurally_misaligned`
   - `rewrite_required`
8. Apply the smallest intervention that closes the gap.
9. Re-check against both shared rules and the directory-specific rules.

## Deterministic Evaluation Output

Every review pass must end with one normalized evaluation record.

Default human-readable format:

```markdown
## Evaluation Record
- Path: [.claude/skills/example/SKILL.md] or [.claude/agents/example.md]
- Catalog state: active | staged placeholder | archived/reference
- Domain lane: skill -> backend-platform | qa-testing | infra-reliability | data-engineering | ai-llm | security | meta-catalog; agent -> engineering | data | qa | architecture | infra-reliability | security | ai-platform | orchestration
- Secondary tag: none | language_framework
- Operating role: discover_route | plan_design | execute_build | review_audit | synthesize_document | orchestrate_delegate
- Scope breadth: narrow_card | bounded_task | lane_workflow | cross_lane_orchestrator
- Power surface: advisory_read_only | local_repo_mutation | environment_operator | delegating_cross_system
- Maintenance importance: core_backbone | lane_backbone | specialist | showcase_or_staged
- Risk criticality: low | medium | high | very_high
- Reuse class: global_reusable | lane_reusable | contextual_specialist
- Detail burden: compact | standard | extended | workbench
- Directory-specific form: [filled from skills or agents guide]
- Structural status: aligned | acceptable_with_fixes | structurally_misaligned | rewrite_required
- Recommended action: preserve | refactor_structure | reduce | expand | split | merge | rewrite | stage_or_delete
- Evidence basis:
  - [files, scripts, validators, overlaps, missing sections]
- Notes:
  - [only if needed]
```

Optional machine-readable equivalent:

```json
{
  "path": ".claude/skills/example/SKILL.md",
  "catalog_state": "active",
  "domain_lane": "backend-platform",
  "secondary_tag": null,
  "operating_role": "review_audit",
  "scope_breadth": "narrow_card",
  "power_surface": "advisory_read_only",
  "maintenance_importance": "lane_backbone",
  "risk_criticality": "high",
  "reuse_class": "global_reusable",
  "detail_burden": "compact",
  "directory_form": "compact_guardrail",
  "structural_status": "acceptable_with_fixes",
  "recommended_action": "refactor_structure",
  "evidence_basis": [
    "missing explicit output contract",
    "overlaps with neighboring guardrail"
  ],
  "notes": []
}
```

Governance rule:

- Markdown is the default review artifact.
- JSON is optional and should be used when batch-processing or automation is involved.
- A review without this record is incomplete.

## Deterministic Decision Rules

Use these rules to reduce reviewer drift:

1. Assign shared axes before deciding form or action.
2. Derive `detail_burden` from scope, power, and criticality. Do not guess it from length.
3. Assign directory-specific form only after the shared axes are fixed.
4. Assign `structural_status` before picking `recommended_action`.
5. Choose the smallest valid action:
   - `preserve` when aligned
   - `refactor_structure` when content is sound but form drift exists
   - `reduce` when the file is over-detailed for its form
   - `expand` when a valid form is under-specified
   - `split` when one file contains multiple primary roles or surfaces
   - `merge` when sibling items are near-duplicates
   - `rewrite` when classification or structure is fundamentally broken
   - `stage_or_delete` when the path is only a placeholder or should leave the active catalog
6. If two actions seem possible, choose the less destructive one unless the rewrite triggers explicitly fire.

## Shared Disposition Rules

### Aligned

Use when:

- purpose is clear
- axes classify cleanly
- structure matches expected form
- support depth is proportional
- overlap with neighbors is controlled

### Acceptable With Fixes

Use when:

- purpose is sound but headings/frontmatter drift
- evidence contract is weak but easily restorable
- verbosity is slightly off but role and scope are correct
- support assets exist but need cleanup, renaming, or pruning

Typical intervention:

- structural refactor without changing core content

### Structurally Misaligned

Use when:

- scope is broader or narrower than the current form supports
- a single file is doing multiple primary roles
- the file embeds material that belongs in references/scripts or in a neighboring component
- the file is too light for its power/criticality, or too heavy for its narrow scope

Typical intervention:

- split, merge, or re-form the component before polishing content

### Rewrite Required

Use when:

- trigger conditions are unclear or contradictory
- the component cannot be assigned clean axes without guesswork
- imported/legacy content no longer matches repo intent
- the file duplicates existing coverage without a real boundary
- safety, approval, or evidence requirements are missing on a high-risk surface

Typical intervention:

- reclassify first, then rewrite from a target form

## Integration With Existing Automation

Current repo automation already provides useful foundations:

- catalog metadata validation
- frontmatter validation
- component reference validation
- compact-skill validation
- pattern-card uniqueness validation
- generated skill-index and manifest checks

Future governance automation should extend, not replace, those checks. The highest-value missing checks are:

1. lifecycle-state inventory for empty skill directories
2. skill-form fit checks beyond compact cards
3. agent-family schema checks
4. support-asset justification checks
5. governance metadata inventory generation outside runtime frontmatter

## Repository Execution Model

This framework is intended to be execution-ready for repo-wide normalization work.

### Batch Processing Order

Use this order unless a narrower scoped campaign is explicitly approved:

1. inventory the whole catalog and emit one evaluation record per item
2. classify backbone items first
3. normalize shared forms and shared families
4. process lane-specific specialists
5. process staged placeholders
6. re-run validation and regenerate any derived inventories

Why:

- backbone items define boundaries for specialist items
- family-wide cleanup is more deterministic after the boundary files are stable
- placeholders should be resolved only after active catalog needs are clear

### Parallelization Rules

Safe to process in parallel:

- items in the same phase with no direct cross-reference dependency
- sibling specialists that do not define each other's boundaries
- large families after a canonical example for that family has been stabilized

Do not process in parallel:

- backbone items that route to or constrain other items
- near-duplicate siblings before merge/split decisions are made
- items whose final boundary depends on unresolved neighboring files

### Enforcement Layers

Treat enforcement as three layers:

1. `governance review`
   Human or AI assigns evaluation records and actions.
2. `content normalization`
   Files are edited, split, merged, or rewritten.
3. `repo validation`
   Existing scripts plus future governance validators confirm catalog integrity.

This guide defines layer 1 and the decision rules for layer 2. It does not require full automation before the framework is usable.

## Self-Audit

This framework was checked against the repository with the following questions:

- Are the categories observable from actual files, validators, manifests, and support assets: yes.
- Are the axes distinct: yes. Domain, role, scope, power, importance, risk, and reuse are separable in the current catalog.
- Can borderline cases be classified consistently: yes, because `state` is handled first and `detail burden` is derived rather than guessed.
- Does the framework support execution: yes. It yields repeatable review steps, target forms, and rewrite triggers.
- Does it preserve justified variety: yes. It allows multiple forms while still setting explicit standards for when each form is appropriate.
