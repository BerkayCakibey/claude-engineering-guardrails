---
name: edge-runtime-implement
description: Implement edge functions, middleware, and CDN-adjacent handlers with runtime constraints, cache discipline, and explicit latency-cost tradeoffs.
domain: engineering_delivery
role: execute_build
scope: bounded_task
power: local_repo_mutation
---

# Skill: edge-runtime-implement

## Purpose / Use When

Use this skill when:
- implementing Cloudflare Workers, Vercel Edge, Netlify Edge, service workers, or CDN-adjacent middleware
- changing cache headers, request rewriting, geo-aware behavior, or edge auth gates
- a task must account for tight runtime limits, cold starts, or edge cost and latency tradeoffs

## When Not to Use

Do not use this skill when:
- the work is traditional Node.js or server-only backend code with no edge runtime
- the task is infra provisioning or platform rollout only
- the task is native mobile implementation
- the runtime contract, bindings, or deployment target are unknown

## Input Expectation

Provide:
- the edge runtime or middleware target
- request and response expectations
- cache, auth, and header requirements
- environment bindings or secrets model
- latency, bundle-size, or cost constraints when known

## Steps / Tasks

1. Run `repo-navigator` to locate the edge entry point, local emulation commands, and existing runtime helpers.
2. Confirm the runtime contract and unsupported APIs before editing.
3. Implement the minimal handler or middleware path needed for the requested behavior.
4. Keep cache behavior explicit. Set or preserve headers, TTLs, bypass rules, and error behavior intentionally.
5. Prefer small dependencies, deterministic parsing, and bounded logging suitable for high-request-volume environments.
6. Run local smoke tests or emulator commands if the repo provides them, plus the normal lint, type, and test gates.
7. Report latency, cache, and cost implications directly instead of hiding them inside a generic completion note.
8. Finish with `self-check`.

## Output Contract

Return:
- the runtime target and entry point
- the request, cache, or header behavior that changed
- the local verification path that ran
- the main latency, cache, or cost risks
- any missing runtime evidence that blocked stronger verification

## Tools / Commands

- `rg` for edge entry points, headers, cache, and runtime bindings
- repo-native emulator, test, lint, and type-check commands
- `git diff -- <path>`

## Dependencies

- `repo-navigator`
- `node-implement` or the repo-native implementation skill for the language in use
- `browser-audit` when the changed behavior is browser-visible
- `self-check`

## Example

Implement an edge middleware that redirects unauthenticated requests away from a gated path, sets explicit cache bypass rules for session-aware responses, and proves the behavior with local emulator and test commands.
