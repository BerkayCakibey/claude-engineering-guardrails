# Skills Governance

Use this guide to classify, review, normalize, and add items under `.claude/skills/`.
Read [catalog-governance-summary.md](./catalog-governance-summary.md) first for the shared model. This guide adds skill-specific form rules, support-asset policy, and rewrite triggers.

## What A Skill Is In This Repo

A skill is a reusable runtime instruction surface for a repeatable workflow, decision pattern, review lane, or automation entry point.

A skill is not:

- a placeholder directory
- a raw prompt dump
- a long background essay with no trigger surface
- a full operator manual embedded in `SKILL.md`
- a near-clone of another narrow skill

## Skill-Specific Discovery Findings

Observed active skills: `129`

Observed form families:

- `47` compact pattern cards
- `29` compact guardrails
- `44` standard workflows
- `47` consulting playbooks
- `14` workbench or automation skills
- `4` hybrids

Observed support depth:

- `references/` on `52` skills
- `scripts/` on `19`
- `assets/` on `7`
- `expected_outputs/` on `5`
- `evals/` on `3`

Observed drift:

- no empty skill directories currently remain in the active skill namespace
- a small residual hybrid/imported subset still sits outside the dominant normalized forms
- `38` active skills still carry extra frontmatter keys beyond `name` and `description`
- no active skill currently vendors `node_modules`; if vendoring returns, treat it as a special-case exception, not as a normal pattern

## Skill Classification Process

For each active skill:

1. Assign shared axes from the catalog summary.
2. Determine the skill form profile below.
3. Compare the actual file and support assets against that profile.
4. Decide whether to preserve, repair, restructure, or rewrite.

For a placeholder directory:

1. Mark state as `staged placeholder`.
2. Do not score it as malformed.
3. Decide whether to promote, move, or delete it.

## Mandatory Skill Evaluation Output

Every reviewed skill must produce a normalized evaluation record.

Use the shared template from [catalog-governance-summary.md](./catalog-governance-summary.md) and add these skill-specific fields:

```markdown
## Skill Evaluation Addendum
- Skill form: compact_pattern_card | compact_guardrail | standard_workflow | consulting_playbook | workbench_or_automation
- Command-backed modifier: yes | no
- Support surface:
  - references: yes | no
  - scripts: yes | no
  - assets: yes | no
  - expected_outputs: yes | no
  - evals: yes | no
  - examples: yes | no
- Placeholder status: active | staged_placeholder
- Normalization target: keep_form | convert_form | split | merge | promote_placeholder | delete_placeholder
```

Governance rule:

- A skill review is incomplete if `skill form` and `normalization target` are omitted.
- Use Markdown by default.
- Emit JSON only when building a batch inventory or automation input.

## Skill Form Profiles

These are the target forms that matter in practice. Use the smallest form that fits the classified skill.

### S1. Compact Pattern Card

Use when:

- role is `plan_design`, `review_audit`, or `discover_route`
- scope is `narrow_card`
- power is `advisory_read_only`
- reuse is `global_reusable` or `lane_reusable`

Typical repo examples:

- `agent-development`
- `approval-path-security`
- `regex-vs-llm-structured-text`

Mandatory sections:

- `## Purpose`
- `## Use When`
- `## Do Not Use When`
- `## Focus Checklist`
- `## Evidence To Collect`
- `## Related Skills`
- `## Output Contract`
- `## Group`

Optional sections:

- one short example
- one short reference pointer

Brevity rule:

- Keep the main file compact. If it starts teaching background material instead of enforcing a decision surface, it is no longer a card.

Rewrite triggers:

- missing one of the required headings
- card grows into a pseudo-generalist
- card is highly similar to an adjacent card
- card needs scripts or long examples to be understandable

### S2. Compact Guardrail

Use when:

- role is primarily `review_audit`
- scope is `narrow_card` or `bounded_task`
- importance or criticality is high despite low document length

Typical repo examples:

- `python-quality-review`
- `github-code-review`
- `security-scan`
- `sast-*` specialist lanes

Mandatory sections:

- purpose or review intent
- activation/use-when criteria
- review gates, focus, or checklist
- evidence contract
- output requirements or output contract

Optional sections:

- required inputs
- explicit severity scheme
- references when the review needs canonical criteria

Brevity rule:

- A high-importance guardrail may still be short if the gates are crisp and the evidence contract is explicit.

Rewrite triggers:

- safety-critical review with no evidence requirement
- severity or output shape is implied instead of stated
- the file spends more space on general philosophy than on executable gates

### S3. Standard Workflow Skill

Use when:

- scope is `bounded_task`
- role is `discover_route`, `plan_design`, `execute_build`, or `synthesize_document`
- power is advisory or local, but the task is complete enough to execute end to end

Typical repo examples:

- `repo-navigator`
- `self-check`
- `ops-task-intake`
- `node-implement`

Mandatory sections:

- clear role or purpose
- trigger conditions or input boundary
- step order or workflow
- non-goals or hard limits
- evidence or verification expectations
- output format

Optional sections:

- repo-contract guidance
- references
- dry-run scenarios
- escalation conditions

Detail rule:

- Standard workflow skills should explain execution order and evidence, but should not contain a whole handbook. Move durable depth to `references/`.

Rewrite triggers:

- no explicit non-goals on a broad or overlap-prone skill
- workflow is described but output/evidence is not
- file mixes planning, implementation, and review as equal first-class jobs
- a backbone skill remains too implicit for another reviewer to apply consistently

### S4. Consulting Or Strategy Playbook

Use when:

- the skill is advisory rather than execution-oriented (for example cost, upgrade, or change planning)
- role is `plan_design`, `synthesize_document`, or `review_audit`
- scope is `bounded_task` or `lane_workflow`
- power is advisory
- contextual nuance matters more than shell/tool automation

Typical repo examples:

- `finops-cost-optimization`
- `eks-upgrade-planner`
- `terraform-change-planner`
- `architecture-decision-records`

Mandatory sections:

- when to activate
- context prerequisites or dependency documents
- discovery questions or intake areas
- decision framework or analysis standards
- output structure
- honesty/non-goal boundary when legal, financial, or speculative risk exists

Optional sections:

- templates
- examples
- reference documents

Detail rule:

- Detail is justified when the lane is concept-heavy or error-prone, but repeated generic intake boilerplate should be factored into shared context skills or references.

Rewrite triggers:

- same generic questioning scaffold repeated across sibling skills with little specialization
- excessive theory with weak decision output
- context dependency exists but is only implied
- a playbook contains operational automation that belongs in a workbench

### S5. Workbench Or Automation Skill

Use when:

- scope is `bounded_task`, `lane_workflow`, or `cross_lane_orchestrator`
- power is `local_repo_mutation` or `environment_operator`
- the skill depends on scripts, assets, evals, or generated artifacts
- failure modes are too rich for a single self-contained prompt file

Typical repo examples:

- `browser-audit`
- `incident-commander`
- `skill-creator`
- `skill-tester`
- `mcp-server-builder`

Mandatory `SKILL.md` sections:

- overview or purpose
- when to use
- workflow
- explicit script or tool entry points
- artifact/output locations
- validation path
- non-goals and safety notes
- references/support asset index

Mandatory support behavior:

- `SKILL.md` stays orchestration-focused
- scripts act as reusable black boxes
- long schemas/checklists/examples move to `references/`, `assets/`, or `expected_outputs/`

Examples become mandatory when:

- scripts accept multiple modes or many flags
- external systems are touched
- output artifacts are part of the contract

Rewrite triggers:

- large support surface but no slim orchestration contract
- `SKILL.md` duplicates reference material line by line
- script-backed behavior with no validation or output-path rules
- checked-in dependency trees with no explicit justification and maintenance story

### S6. Command-Backed Utility

This is a modifier, not a standalone family. Apply it when the skill uses `command:` in frontmatter.

Mandatory additions:

- command purpose
- invocation syntax or usage note
- clear distinction between the command alias and the broader workflow
- output expectations

Current repo examples:

- `si-extract`
- `si-promote`
- `si-remember`
- `si-review`
- `si-status`

Rewrite trigger:

- command alias exists but the skill does not explain when the command is preferable to a normal invocation

## Frontmatter Policy

### Required Runtime Fields

- `name`
- `description`

### Approved Runtime Extensions

- `argument-hint`
- `disable-model-invocation`
- `command`
- `domain`
- `role`
- `scope`
- `power`

### Governance Rule

Do not add governance-only metadata to runtime frontmatter by default.

Why:

- `docs/authoring/skill-authoring-checklist.md` already says `SKILL.md` should contain invocation-time instructions only.
- category, criticality, importance, and rewrite state are review metadata, not runtime prompt inputs.

Balanced-expansion note:

- `domain`, `role`, `scope`, and `power` remain acceptable when they help classify reusable skills in maintainer-side catalog tooling.
- Additional execution-layer mirrors are not required contracts for the main library surface.
- Do not add additional governance metadata beyond these fields without a clear packaging or catalog reason.

### Exceptions

Existing non-standard frontmatter should be treated as one of three cases:

1. `grandfathered and harmless`
   Keep only if it is intentionally used by repo tooling.
2. `content migration candidate`
   Move provenance or maintenance data to an external governance registry.
3. `drift`
   Remove during normalization.

Current likely migration candidates:

- `architecture-decision-records`
- `golang-pro`
- `tdd-guide`

## Support Asset Policy

### `references/`

Use for:

- detailed criteria
- long examples
- templates
- background material required only in some invocations

Do not use for:

- hiding required runtime instructions that the main skill cannot function without

### `scripts/`

Use for:

- repeatable automation
- deterministic validation
- artifact generation

Requirements:

- script entry points must be named in `SKILL.md`
- validation path must be explicit
- output paths must be explicit when scripts generate files

### `assets/`

Use for:

- stable templates
- report skeletons
- fixtures that are consumed by the workflow

### `expected_outputs/` and `evals/`

Use only when the skill needs evaluation or exemplar artifact contracts.

### `examples/`

Use when examples are genuinely executed or compared, not as a dumping ground.

### `README.md`

Allowed only when the support surface is large enough that maintainers need an extra operator-facing overview beyond `SKILL.md`.

### `node_modules`

Disallowed by default.

Exception bar:

- vendoring is intentional
- provenance is clear
- validation depends on it
- there is a maintenance owner and update strategy

Without that bar, rewrite the packaging approach.

## Combination Rules That Matter In Practice

### High Importance + Low Detail

Correct shape:

- compact guardrail or standard workflow

Must still include:

- clear trigger
- hard boundaries
- explicit evidence/output contract

Typical examples:

- `repo-navigator`
- `self-check`
- `security-scan`

### High Importance + High Detail

Correct shape:

- workbench or extended standard workflow

Must move depth out of the main file:

- use `references/`, `scripts/`, `assets/`

### Low Importance + High Detail

Allowed only when:

- the task is genuinely complex
- external systems or specialized reasoning justify the depth

Otherwise:

- reduce
- merge into a broader skill
- or demote to reference material

### High Criticality + High Reuse

Must include:

- explicit non-goals
- evidence contract
- validation path
- overlap boundaries with adjacent skills

### Narrow Scope + High Detail

Usually indicates one of three failures:

- too much background in the main file
- the wrong form was chosen
- the skill should be merged into a broader workflow plus a smaller reference

## Repo-Wide Execution Order For Skills

When processing the entire skills catalog, use this order:

1. `core_backbone` skill workflows
2. shared compact families
3. lane backbones
4. workbench and automation skills
5. contextual specialists
6. staged placeholders

### Phase 1: Core Backbone

Start with skills that define repo-wide behavior or downstream boundaries, such as:

- `task-dispatcher`
- `repo-navigator`
- `self-check`
- `test-strategy-planner`
- `skill-creator`
- `skill-tester`

Why:

- many later skills either route to these or assume their execution style

### Phase 2: Shared Compact Families

Normalize family-wide forms after the backbone is stable:

- compact pattern cards
- compact guardrails

Why:

- these families benefit most from canonical examples and repeatable enforcement

### Phase 3: Lane Backbones

Process lane-defining workflows next, for example:

- `node-implement`
- `python-code-implementer`
- `terraform-change-planner`
- `incident-commander`
- `browser-audit`

### Phase 4: Workbench And Automation

Only after lane boundaries are clear:

- script-backed
- asset-backed
- eval-backed
- artifact-generating skills

### Phase 5: Contextual Specialists

Long-tail specialists can then be normalized in parallel within their lanes.

### Phase 6: Staged Placeholders

For empty skill directories, choose one outcome:

- promote into active skill
- move to a staging/reference area
- delete

Do not leave them as ambiguous top-level catalog entries.

## Skill Parallelization Rules

Safe to process in parallel:

- specialists within the same lane after the lane backbone is stable
- compact cards with no overlap risk after a canonical family template is fixed
- placeholder directories after active coverage decisions are complete

Do not process in parallel:

- backbone routing skills
- sibling skills with likely merge/split decisions
- large GTM playbooks that still depend on unresolved context-foundation boundaries

## Review And Rewrite Workflow For Skills

1. Confirm whether the directory is active or staged.
2. Assign shared axes.
3. Choose the target skill form.
4. Audit the file against:
   - trigger clarity
   - role purity
   - scope fit
   - explicit evidence/output contract
   - support-depth proportionality
   - sibling overlap
5. Choose intervention level:
   - preserve
   - structure-only refactor
   - expand missing boundaries/evidence
   - reduce and move depth out
   - split or merge
   - rewrite
6. Re-check against existing validators and the form profile.

Mandatory closing artifact:

- one shared evaluation record
- one skill addendum
- one explicit normalization target

## Merge, Split, And Placeholder Rules

Merge when:

- two narrow cards differ mostly by wording
- reuse class and operating role are the same
- examples and evidence contract are substantially identical

Split when:

- one skill has multiple primary roles
- one skill crosses domain lanes without acting as an orchestrator
- a file mixes context foundation, execution, and review into one prompt

Keep intentionally lightweight when:

- scope is narrow
- power is advisory
- neighboring workflow skills already provide the heavier context

Placeholder policy:

- empty directories are not active skills
- they should either be promoted to active, moved to an explicit staging area, or deleted
- do not count them as coverage
- do not leave them in place indefinitely without ownership

## Quality Standard For New Skills

A new skill is ready when:

- its trigger surface is specific
- its form profile is obvious
- its runtime file contains only invocation-time instructions
- its detail burden matches its scope and power
- its support assets are justified
- it is distinguishable from adjacent skills
- another reviewer can classify and review it without guessing
