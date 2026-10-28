# Getting Started

This repository is a source library.
You do not run it directly.
Do not run normal Claude sessions from this repository root.

## Before Copying Components

- Read [../TIPS.md](../TIPS.md) before installing many components globally.
- Start from [recommended-components.md](./recommended-components.md) if you want a role-based starter set.
- Start from [use-cases.md](./use-cases.md) if you want scenario-based guidance.
- Do not copy the entire catalog globally.
- Copy only project-relevant components.
- Optional local context files such as `.claude/knowledge/` are user-owned state in your own setup. They are not required for normal component copying and should stay uncommitted by default.
- Keep long plans in files instead of relying on chat history alone.
- Use hooks carefully and keep human approval for risky actions.
- Prefer a small maintained setup over a huge global setup.

## Installation Model

Browse the categorized source tree in this repo, then copy selected components
into the flat structure Claude expects in your own environment.

| Source in this repo | Destination in your setup |
|---|---|
| `.claude/skills/<domain>/<skill-name>/` | `~/.claude/skills/<skill-name>/` |
| `.claude/agents/<domain>/<agent-name>.md` | `~/.claude/agents/<agent-name>.md` |
| `.claude/commands/<command>.md` | `~/.claude/commands/<command>.md` |
| `.claude/rules/<rule>.md` | `~/.claude/rules/<rule>.md` |
| `.claude/hooks/<hook>` | `~/.claude/hooks/<hook>` |

## Fastest Path

1. Choose from [recommended-components.md](./recommended-components.md) or [use-cases.md](./use-cases.md).
2. Copy the source directories or files you want.
3. Keep the destination names flat.

## Example Copy

```bash
mkdir -p ~/.claude/skills ~/.claude/agents ~/.claude/commands ~/.claude/rules ~/.claude/hooks

cp -R .claude/skills/meta-catalog/repo-navigator ~/.claude/skills/repo-navigator
cp -R .claude/skills/qa-testing/browser-audit ~/.claude/skills/browser-audit
cp .claude/agents/engineering/developer.md ~/.claude/agents/developer.md
cp .claude/commands/code-review.md ~/.claude/commands/code-review.md
cp .claude/hooks/pretooluse-guard.sh ~/.claude/hooks/pretooluse-guard.sh
```

## Important Rule

Copy the whole skill directory, not only `SKILL.md`.
If a skill ships `references/`, `scripts/`, `assets/`, `examples/`, or
`expected_outputs/`, those sibling paths are part of the component.

Commands and rules are optional single-file copies. Add them only when they
match how you actually work.

## Optional Local Context Files

Some self-improvement components can optionally create local state such as
`.claude/knowledge/`.

If those files are missing, the related agents or skills should ask for context
or proceed with explicit assumptions instead of treating them as required repo
files.

## Hooks And Settings

Hooks are optional.
You can copy individual hook files from `.claude/hooks/` into your own
`~/.claude/hooks/` directory.

Settings are optional and are intentionally not part of the public component
library surface. Start with copyable components under `.claude/` first.

## Do not bulk-copy the whole catalog

- Start from the use-case guide or a single clear need.
- Start from [recommended-components.md](./recommended-components.md) if you want a smaller role-based set.
- Copy only the components you understand and intend to use.
- Avoid bringing in commands, hooks, or maintainer-only files by default.
