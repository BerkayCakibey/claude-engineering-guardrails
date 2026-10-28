# Repo Contracts

Inspect the repo before editing. The contract is usually already declared.

## What to Read First

1. `package.json`
2. lockfile
3. `tsconfig.json` or equivalent
4. top-level README or contributing section
5. nearby package/example files if it is a monorepo

In monorepos, inspect both:

- workspace root contract
- touched package contract

## Detect the Module System

- `"type": "module"` -> ESM by default
- no `"type"` -> CommonJS by default unless the repo uses `.mjs`, transpilation, or bundler conventions
- mixed repos may isolate module type per package; do not generalize from the workspace root blindly

Do not convert ESM/CJS as part of an unrelated task.

## Detect the Change Surface

Prefer the smallest viable patch:

- CLI tool:
  - inspect `bin`, `dist`, `src/cli`, `README` help snippets
- library/SDK:
  - inspect exports, emitted files, build scripts, tests
- frontend app:
  - inspect `vite.config.*`, `src/`, lint config, test setup
- backend/service:
  - inspect entrypoint, env handling, request handlers, tests

## Monorepo Rules

- Work at the package level when possible
- Run package-scoped scripts when the repo supports them
- Do not run whole-workspace commands unless the change surface or repo contract requires it
- Check for workspace declarations such as:
  - `workspaces`
  - `pnpm-workspace.yaml`
  - Turborepo/Nx task wrappers
