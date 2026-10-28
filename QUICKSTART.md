# Quickstart

This repository is a component library, not a runtime workspace.
Do not run normal Claude sessions from this repository root.

## Before Copying Components

- Read [TIPS.md](./TIPS.md) before installing many skills, agents, or hooks globally.
- Start from [docs/recommended-components.md](./docs/recommended-components.md) or [docs/use-cases.md](./docs/use-cases.md).
- Do not copy the entire catalog globally.
- Copy only project-relevant components.
- Optional local context files such as `.claude/knowledge/` belong to your own setup. They are not required for normal component copying and should stay uncommitted by default.
- Keep long plans in files so they survive session changes.
- Use hooks carefully and keep human approval for risky actions.
- Prefer a small maintained setup over a huge global setup.

## Fastest Safe Path

1. Choose a starter set from [docs/recommended-components.md](./docs/recommended-components.md) or [docs/use-cases.md](./docs/use-cases.md).
2. Copy one skill directory into your own `~/.claude/skills/`.
3. Copy one agent file into your own `~/.claude/agents/`.
4. Add commands, rules, hooks, or settings only when you understand why you need them.

## Copy One Skill

```bash
mkdir -p ~/.claude/skills
cp -R .claude/skills/meta-catalog/repo-navigator ~/.claude/skills/repo-navigator
```

Copy the whole skill directory, not only `SKILL.md`.

## Copy One Agent

```bash
mkdir -p ~/.claude/agents
cp .claude/agents/engineering/developer.md ~/.claude/agents/developer.md
```

## Commands, Rules, and Hooks

- Commands and rules are optional single-file copies.
- Hooks can be copied directly from [`.claude/hooks/`](./.claude/hooks), but enable them one by one.

## Do Not Copy Blindly

- Do not copy the entire catalog into your setup.
- Do not assume a skill or agent is useful just because it exists.
- Do not bring in maintainer-only or local-only files by default.

For the full install model, read [docs/getting-started.md](./docs/getting-started.md).
