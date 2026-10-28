---
name: node-implement
description: Implement JavaScript, TypeScript, and Node.js changes with repo-native tooling, minimal change surface, and verifiable quality gates.
argument-hint: "[task description]"
disable-model-invocation: false
---

# Skill: node-implement

## Purpose
Implement Node.js, JavaScript, and TypeScript changes with predictable repo-native workflows and verification.

## Trigger Conditions
Use this skill when:
- adding or changing JS/TS/Node code
- fixing Node.js or frontend/tooling bugs
- working in repos with `package.json`, lockfiles, Vite, Jest, Vitest, ESLint, Prettier, tsup, tsx, or `tsc`
- implementing CLI tools, scripts, SDKs, UI projects, or backend services in the Node ecosystem

## Step Order (Mandatory)
1. Detect the repo contract before editing.
2. Implement the smallest working change.
3. Add or update tests when behavior changes.
4. Run repo-native quality gates in the project's preferred order.
5. Report functional impact and concrete verification evidence.

## Repo Contract

Before editing:

1. Detect the package manager from, in order:
   - `packageManager` in `package.json`
   - `pnpm-lock.yaml`
   - `package-lock.json`
   - `yarn.lock`
   - `bun.lockb` or `bun.lock`
2. Inspect `package.json` for:
   - `scripts`
   - `type`
   - `engines`
   - workspace hints
   - package-local overrides in monorepos
3. Detect language/tooling:
   - TypeScript: `tsconfig.json`, `.ts` sources, `typescript` dep
   - lint/format: `eslint`, `prettier`, biome, xo
   - tests: `vitest`, `jest`, playwright, cypress
   - build: `tsup`, `vite`, `rollup`, `webpack`, `tsc`
4. Follow the repo's package manager and scripts. Do not swap tools unless asked.

Read [references/repo-contracts.md](references/repo-contracts.md) for the detection matrix and local reference examples.

## Quality Gates

Run the strongest repo-native gates available. Prefer explicit repo scripts over guessed commands.

Typical order:

1. install if needed using the repo's package manager
2. lint
3. format check
4. type-check
5. tests
6. build when the change affects packaging, bundles, or emitted output

In monorepos, prefer package-scoped commands over whole-workspace commands unless the workspace contract says otherwise.

Read [references/quality-gates.md](references/quality-gates.md) for command selection rules.

## Backend Service Gates

When the change touches API routes, service layers, repositories, database
queries, caches, queues, or server-side integrations, apply
[references/backend-service-gates.md](references/backend-service-gates.md). Keep
the implementation aligned with existing repo boundaries rather than forcing a
generic backend architecture.

## Type Contract Gates

When TypeScript changes add or reshape domain types, DTOs, schema-derived
types, API clients, SDK contracts, or state machines, apply
[references/type-contract-gates.md](references/type-contract-gates.md). Prefer
clear invariants and boundary parsing over broad `any` or unsafe assertions.

## Hard Rules

- Do not assume `npm` if the repo is on `pnpm`, `yarn`, or `bun`.
- Do not change the package manager, lockfile strategy, or module system unless explicitly asked.
- Do not introduce TypeScript into a JS repo or vice versa without a clear requirement.
- Do not claim completion without verification evidence. If a gate cannot run, say so directly.
- Update tests when behavior changes or a bug is fixed.
- If user-facing behavior changes, update inline help, examples, or docs when the repo already follows that pattern.
- If the repo exposes package-scoped scripts or filters, prefer those to broad workspace runs.

## Output Format
1. Plan
2. Implementation
3. Evidence
4. Risk
5. Next Step

## References
- Repo/tool detection: [references/repo-contracts.md](references/repo-contracts.md)
- Quality-gate selection: [references/quality-gates.md](references/quality-gates.md)
- Backend service gates: [references/backend-service-gates.md](references/backend-service-gates.md)
- Type contract gates: [references/type-contract-gates.md](references/type-contract-gates.md)

## Learnings
- The biggest Node mistake is guessing the toolchain instead of reading the repo's contract first.
