# Node Quality Gates

Select commands from the repo instead of inventing them.

## Package Manager Detection

Use the repo's declared tool:

1. `package.json` -> `packageManager`
2. `pnpm-lock.yaml` -> `pnpm`
3. `package-lock.json` -> `npm`
4. `yarn.lock` -> `yarn`
5. `bun.lockb` / `bun.lock` -> `bun`

If install is required, prefer:

- `pnpm install --frozen-lockfile` when the repo is already pinned and CI-like behavior is desired
- `npm ci` when `package-lock.json` exists and a clean install is appropriate
- `yarn install --immutable` for Berry-style repos when configured
- `bun install --frozen-lockfile` where supported

Avoid changing lockfiles unless the task requires dependency updates.

## Command Selection

Prefer repo scripts:

- lint:
  - `pnpm lint`
  - `npm run lint`
  - `yarn lint`
  - `bun run lint`
- format:
  - `pnpm format`
  - `npm run format`
  - `yarn format`
  - `bun run format`
  - `pnpm prettier --check .`
  - repo-specific `format:check`
- type-check:
  - `pnpm typecheck`
  - `npm run typecheck`
  - `yarn typecheck`
  - `bun run typecheck`
  - `tsc --noEmit` only if the repo has TypeScript but no script
- tests:
  - `pnpm test`
  - `npm test`
  - `yarn test`
  - `bun test`
  - `pnpm vitest run`
  - `pnpm jest`
- build:
  - `pnpm build`
  - `npm run build`
  - `yarn build`
  - `bun run build`

## Fallback Rules

Only use fallbacks when the repo has no script:

- ESLint: `npx eslint .`
- Prettier: `npx prettier --check .`
- TypeScript: `npx tsc --noEmit`
- Vitest: `npx vitest run`
- Jest: `npx jest`

If fallback use would require dependency downloads or change the environment, call that out.

## Monorepo Guidance

Prefer the narrowest package-scoped command available. Examples:

- `pnpm --filter <pkg> test`
- `pnpm --filter <pkg> build`
- `npm run test --workspace <pkg>`
- `yarn workspace <pkg> test`
- `bun run --filter <pkg> test`

Only run full-workspace verification when:

- the touched package is shared across the workspace
- root scripts are the only supported contract
- build graph coupling makes package-scoped verification misleading

## Verification Minimums

- Bug fix: relevant tests + lint/type-check if present
- Library/API change: tests + type-check + build when exports/emitted files matter
- CLI change: tests if present, plus `--help` or representative command verification when possible
- Frontend/UI change: lint + build at minimum, plus tests if present
