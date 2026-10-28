# Agents Governance

Use this guide to classify, review, normalize, and add items under `.claude/agents/`.
Read [catalog-governance-summary.md](./catalog-governance-summary.md) first for the shared model. This guide adds agent-specific authority classes, frontmatter expectations, and rewrite rules.

## What An Agent Is In This Repo

An agent is a single-file runtime role with an explicit tool surface and a bounded authority model.

An agent is not:

- a mini skill catalog
- a full domain handbook
- a generic catch-all persona with fuzzy boundaries
- a placeholder for future work

In this repo, agents should be the narrowest durable role that justifies a separate tool surface or delegation target.

## Agent-Specific Discovery Findings

Observed agents: `39`

Observed authority families:

- `22` read-only reviewers
- `4` read-only operators
- `17` execution specialists
- `3` orchestrators

Observed consistency:

- all agents are single-file
- all agents have `name`, `description`, `tools`, and `maxTurns`
- reviewer agents are already mostly standardized around `Read, Grep, Glob`

Observed drift:

- active agents now carry explicit `model` and `permissionMode`
- `jira-ops` has external-system mutation tools without local repo write tools, so authority inventories must look beyond `Edit` and `Write`
- tool ordering is inconsistent
- some execution/orchestrator agents contain domain playbook material better suited to skills or references
- older agents sometimes use looser heading styles than the reviewer family

## Agent Classification Process

For each agent:

1. Assign shared axes from the catalog summary.
2. Assign the agent authority profile below.
3. Compare the actual file against that profile.
4. Decide whether the file is aligned, fixable, misaligned, or rewrite-worthy.

## Mandatory Agent Evaluation Output

Every reviewed agent must produce a normalized evaluation record.

Use the shared template from [catalog-governance-summary.md](./catalog-governance-summary.md) and add these agent-specific fields:

```markdown
## Agent Evaluation Addendum
- Authority profile: read_only_reviewer | read_only_operator | execution_specialist | orchestrator
- Tool surface class: read_only | read_only_plus_operator | write_capable | delegating
- Frontmatter status:
  - model explicit: yes | no
  - permissionMode explicit: yes | no
  - tool ordering normalized: yes | no
- Normalization target: keep_profile | tighten_body | normalize_frontmatter | reduce_handbook_content | split_authority | merge_agent | rewrite_agent
```

Governance rule:

- An agent review is incomplete if `authority profile`, `tool surface class`, or `normalization target` is missing.
- Use Markdown by default.
- Emit JSON only for inventories or automation input.

## Agent Authority Profiles

### A1. Read-Only Reviewer

Use when:

- role is `review_audit`
- power is `advisory_read_only`
- scope is `bounded_task`
- the agent exists to produce findings, not to execute changes

Typical repo examples:

- language reviewers
- `database-reviewer`
- `code-explorer`
- `doc-updater`
- `plugin-validator`

Expected frontmatter:

- `name`
- `description`
- `model`
- `tools: Read, Grep, Glob`
- `permissionMode: default`
- `maxTurns`

Expected body:

- short role statement
- focus, operating rules, or verification focus
- explicit output format
- optional evidence or open-questions sections when the lane needs them

Brevity rule:

- Brevity is correct here. A reviewer brief should usually stay short enough that the model loads the role quickly and spends context on repo evidence instead of self-description.

Rewrite triggers:

- long domain tutorial with little review specificity
- missing output format
- write-capable or operator instructions embedded into a reviewer
- weak separation between confirmed findings and inference

### A2. Read-Only Operator

Use when:

- role is `discover_route`, `plan_design`, or `review_audit`
- power is read-only but includes `Bash` or connector tooling
- the agent inspects operational systems or external state without changing them

Typical repo examples:

- `cloud-architect`
- `jira-ops` in read-mostly planning mode
- `rca-readonly-analyst`
- `sre-engineer` when used diagnostically

Expected frontmatter:

- same core fields as A1
- explicit tool surface including `Bash` and/or connector tools
- `permissionMode` should be explicit even if default

Expected body:

- role and safe posture
- what may be inspected
- what must never be executed
- output/report shape
- optional read-only command guidance

Detail rule:

- These agents can be longer than reviewers because command posture matters, but they still should not become full runbooks. Durable lane procedures belong in skills and references.

Rewrite triggers:

- operational commands are suggested without safe posture
- agent mixes read-only analysis and execution authority without saying which takes precedence
- domain checklists dominate the file and crowd out the delegation boundary

### A3. Execution Specialist

Use when:

- role is `execute_build`, `plan_design`, or `synthesize_document`
- tools include `Edit`, `Write`, `Bash`, `Skill`, or equivalent
- the agent owns one meaningful lane but is not a global orchestrator

Typical repo examples:

- `developer`
- `debugger`
- `tester`
- `security`
- `devops-engineer`

Expected frontmatter:

- `name`
- `description`
- `model`
- explicit write-capable tool list
- explicit `permissionMode`
- `maxTurns`

Expected body:

- role statement
- lane responsibilities
- workflow or execution order
- when to invoke related skills
- hard boundaries and non-goals
- output or report format

Detail rule:

- Execution specialists need enough detail to route safely and use skills well.
- They should not absorb every lane-specific checklist. Heavy lane knowledge should move into skills so the agent remains a role contract, not a handbook.

Rewrite triggers:

- the agent contains long embedded methodology that belongs in skills
- no mention of skill delegation even though the lane clearly has skills
- execution authority exists but verification/reporting is absent
- the agent behaves like an orchestrator across multiple lanes

### A4. Orchestrator

Use when:

- role is `orchestrate_delegate`
- scope is `cross_lane_orchestrator`
- power is `delegating_cross_system`
- the agent coordinates other agents and skills

Typical repo examples:

- `team-lead`
- `incident-commander`

Expected frontmatter:

- same core fields as A3
- `Agent` in the tool list
- explicit model and permission mode

Expected body:

- orchestration purpose
- delegation rules
- approval/escalation policy
- progress reporting rules
- stop conditions
- failure handling
- report format

Detail rule:

- Orchestrators need the clearest boundaries in the catalog.
- They should describe how they route and when they stop.
- They should not inline every subordinate lane playbook.

Rewrite triggers:

- approval logic is ambiguous
- the orchestrator duplicates subordinate skill or agent manuals
- it claims universal scope without explicit routing limits
- it cannot be classified cleanly apart from a broad execution specialist

## Agent Frontmatter Policy

### Required Fields For New Or Normalized Agents

- `name`
- `description`
- `model`
- `tools`
- `permissionMode`
- `maxTurns`

### Governance Rules

- `model` and `permissionMode` should be explicit on every agent after normalization.
- The file stem must remain the runtime identifier.
- Tool lists should be ordered consistently.

Recommended order:

- `Read, Grep, Glob`
- add `Bash`
- add `Edit, Write`
- add `Agent`
- add `Skill`
- add connector tools last

This order is not semantic runtime behavior. It is a readability and reviewability standard.

### Model Naming

- Agent frontmatter uses tier aliases only: `model: sonnet`, `model: opus`, `model: haiku`, or `model: inherit`. Claude Code resolves the alias to the current model of that tier, so nothing changes when a new model ships.
- Scripts and code examples read the model from `ANTHROPIC_MODEL` and fail with a clear message when it is unset; cost tables are keyed by tier (`opus`, `sonnet`, `haiku`).
- Prose says "the current Sonnet-class model" or "your configured model"; illustrative snippets use `<model-id>`.
- No model ID is hard-coded anywhere in the repo. Verify with:

```bash
git grep -n -i -E 'claude-[0-9]|claude-(opus|sonnet|haiku|fable)-[0-9]|(opus|sonnet|haiku)-[0-9]'
```

An empty result is the expected state.

### Description Standard

The description must answer both:

- what the agent does
- when it should be invoked instead of a nearby agent

Common failure:

- descriptions that read like long marketing blurbs rather than routing criteria

## Agent Body Standard

### Mandatory For All Agents

- explicit role
- clear boundary or non-goal
- output/report expectation

### Mandatory For High-Power Agents

- escalation/approval posture
- verification or reporting rule
- clear relationship to neighboring skills and agents

### Usually Optional

- long examples
- exhaustive domain checklists
- reference catalogs

If those become necessary, put them in skills or repo docs instead.

## Combination Rules That Matter In Practice

### High Importance + Low Detail

Correct shape:

- read-only reviewer brief

This is common and healthy in this repo. The file still must contain:

- routing clarity
- output format
- clear boundaries

### High Importance + High Detail

Correct shape:

- execution specialist or orchestrator

But:

- high detail must mainly describe routing, authority, and reporting
- deep lane procedures should move to skills

### Low Importance + High Detail

Usually wrong for agents.

Default action:

- reduce
- move lane detail to a skill
- or merge into an existing specialist if the authority surface is the same

### High Criticality + Read-Only

Common for reviewers and safety operators.

Mandatory:

- sharp evidence discipline
- no speculative commands
- explicit statement of what is not being changed

### Broad Scope + Execution Authority

Only acceptable for true orchestrators.

If a lane specialist starts coordinating other agents, either:

- promote it into an orchestrator profile
- or narrow it back to its lane

## Repo-Wide Execution Order For Agents

When processing the entire agent catalog, use this order:

1. orchestrators
2. core execution specialists
3. read-only reviewer families
4. read-only operators
5. long-tail execution specialists

### Phase 1: Orchestrators

Start with:

- `team-lead`
- `incident-commander`

Why:

- these files define top-level delegation boundaries for the rest of the catalog

### Phase 2: Core Execution Specialists

Next stabilize the most delegated execution lanes, such as:

- `developer`
- `tester`
- `debugger`
- `security`

Why:

- orchestrators and commands depend on these boundaries being clear

### Phase 3: Read-Only Reviewer Families

Normalize the short reviewer family after execution boundaries are stable:

- language reviewers
- artifact reviewers
- focused read-only analyzers

Why:

- they are the easiest family to standardize once authority rules are settled

### Phase 4: Read-Only Operators

Process operational read-only agents after reviewers:

- `cloud-architect`
- `jira-ops`
- `rca-readonly-analyst`
- `sre-engineer`
- `memory-analyst`

### Phase 5: Long-Tail Execution Specialists

Finish with more contextual lane executors or domain-specific specialists.

## Agent Parallelization Rules

Safe to process in parallel:

- language reviewer agents after one canonical reviewer profile is stabilized
- read-only analyzers with no routing overlap
- contextual execution specialists after orchestrator and core executor boundaries are fixed

Do not process in parallel:

- orchestrators
- adjacent agents with unclear authority overlap
- agents that are likely to be merged or split
- files whose frontmatter/tool-surface policy is still unresolved

## Review And Rewrite Workflow For Agents

1. Assign shared axes.
2. Assign the authority profile.
3. Audit the file against:
   - routing clarity
   - authority clarity
   - tool surface fit
   - non-goals/boundaries
   - output/report contract
   - lane-specific material that should move to skills
4. Choose intervention level:
   - preserve
   - normalize frontmatter
   - tighten body and remove handbook material
   - split or merge authority
   - rewrite
5. Re-check against AGENTS inventory and routing references.

Mandatory closing artifact:

- one shared evaluation record
- one agent addendum
- one explicit normalization target

## Merge, Split, And Rewrite Rules

Merge when:

- two agents share the same authority profile and tool surface
- their routing boundary differs only by wording
- a specialist agent adds no unique review or execution discipline

Split when:

- one agent mixes reviewer and executor roles
- one agent mixes lane work and orchestration
- connector/operator behavior overwhelms the base role

Rewrite when:

- an agent lacks an explicit authority profile
- frontmatter is incomplete enough to obscure routing
- the body is mostly a domain manual rather than an agent contract
- its nearest adjacent agent can already do the same job with the same tool surface

Leave intentionally brief when:

- the agent is read-only
- the lane has strong shared standards elsewhere
- more detail would only repeat skills or docs

## Quality Standard For New Agents

A new agent is ready when:

- its tool surface is the minimum needed
- its routing boundary is distinct from nearby agents
- its authority profile is obvious
- its body explains how it should act, not everything it knows
- it delegates deep lane methodology to skills when appropriate
- another reviewer can tell when to use it and when not to use it
