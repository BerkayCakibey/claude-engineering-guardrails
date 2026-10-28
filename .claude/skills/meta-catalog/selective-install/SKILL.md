---
name: selective-install
description: >-
  Design manifest/profile based component installs for Claude, Codex, Cursor, and similar harnesses without overloading global context.
---

# Skill: selective-install

## Purpose
Design a minimal install plan instead of copying the whole depot into every runtime.

## Trigger Conditions
- A user wants to publish or copy only part of this depot.
- A project has limited token budget and only needs specific lanes.
- You need to map skills, agents, hooks, commands, and rules into another harness cleanly.

## Input Boundary
- Identify the target runtime first: Claude, Codex, Cursor, or another harness with equivalent install mechanics.
- Confirm whether the user needs a global install, a project-local install, or a split between the two.
- Inspect manifest and profile evidence before recommending components by name.
- Treat token budget, always-on safety posture, and project-specific workflow depth as first-class constraints.

## Step Order
1. Start from the target workflow, not from raw catalog size.
2. Keep hooks global only when the user wants the same safety posture everywhere.
3. Prefer project-relevant skills over broad global installs.
4. Separate:
   - always-on core
   - project-specific add-ons
   - optional deep-review packs
5. Use manifest/profile evidence rather than hand-wavy "install what you need" advice.

## Evidence Expectations
- Cite the specific manifest entries, install profiles, or routed component groups that justify the recommendation.
- Name what stays global, what moves project-local, and what should not be installed at all.
- Call out missing dependencies such as `jq`, `rsync`, browser tooling, or harness-specific requirements.
- Explain the token-cost or context-load tradeoff for the proposed split.

## Deliverables
- recommended profile or manual component list
- what stays global vs project-local
- token cost tradeoff
- any missing dependencies such as `jq`, `rsync`, or browser tooling

## Output Requirements
```markdown
## Target Workflow
- [what the consumer wants to do]

## Install Plan
- Core: [always-on pieces]
- Optional: [workflow-specific pieces]
- Avoid: [unnecessary global load]

## Rationale
- [why this split is better than full install]

## Verification
- [commands or file checks to confirm the install]
```

## Non-Goals
- Do not recommend full-catalog installs when the workflow only needs a narrow lane.
- Do not blur manifest-driven installs and manual component copies into the same plan without saying which one applies.
- Do not assume all hooks or commands should be globally installed by default.
