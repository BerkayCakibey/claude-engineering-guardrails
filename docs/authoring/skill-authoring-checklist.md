# Skill Authoring Checklist

Use this checklist before adding or changing active skills, agents, commands, hooks, or rules. The goal is to keep this component library small, inspectable, and useful for daily work.

## Scope Gate

- The skill solves a repeated local workflow, not a one-off idea.
- The skill has a clear trigger condition in its description.
- The skill does not duplicate an existing skill, command, or rule.
- The skill keeps community-growth mechanics out of scope.
- External source material is adapted as a pattern, not copied as a catalog.

## Structure Gate

- `SKILL.md` contains only the instructions needed at invocation time.
- Short `SKILL.md` files are acceptable only when they are clearly scoped pattern cards with one narrow decision surface.
- Long examples, schemas, or background material live in `references/`.
- Reusable commands or automation live in `scripts/`.
- Large examples live in `examples/` only when they are actually used.
- The skill names expected inputs, outputs, and non-goals.

## Execution Gate

- Prefer bundled scripts as black boxes: run `--help` before reading or changing large script internals.
- The skill tells the agent what evidence to collect before claiming completion.
- File outputs are written to local artifact paths when they are not source material.
- Any network, credential, browser, or external app action is explicit and bounded.
- If a workflow can mutate user systems, it must have a safety note and validation path.

## Quality Gate

- The skill has at least one dry-run scenario or acceptance checklist.
- The skill can be validated by an existing script, syntax check, or generated index.
- New active files update the maintained validation workflow and affected indexes when counts, docs, hooks, settings, or public policy are affected.
- New external-source decisions update `config/external-repo-decisions.json` or the external review docs when relevant.
- Compact pattern cards should be merged or deleted when they become pseudo-generalist clones of existing skills.

## Do Not Add

- bulk skill catalogs
- unreviewed prompt dumps
- long-running daemons
- telemetry/update checks
- OAuth or SaaS action surfaces
- contribution templates, issue templates, pull request templates, or changelog machinery
