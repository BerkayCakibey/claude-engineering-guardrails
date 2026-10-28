---
name: api-integration-implement
description: Implement or harden third-party API clients, webhook consumers, and provider sync paths with explicit auth, retry, idempotency, and contract verification.
domain: "backend-platform"
role: execute_build
scope: bounded_task
power: local_repo_mutation
---

# Skill: api-integration-implement

## Purpose / Use When

Use this skill when:
- implementing or repairing an outbound client to a third-party API
- adding or hardening inbound webhook handlers
- changing pagination, rate-limit, retry, timeout, dedupe, or sync behavior
- a provider contract changed and the repo must adapt safely

## When Not to Use

Do not use this skill when:
- the task is internal API design only; use `api-design-reviewer`
- the task is business-process design for billing or customer operations with no code delivery
- the provider contract, event shape, or auth model cannot be identified from repo evidence or supplied docs
- the work is a broad product slice where the integration is only one small part of the change

## Input Expectations

Provide:
- provider name and the affected endpoint, event, or resource family
- request or event contract, including sample payloads when available
- auth, signing, pagination, rate-limit, and idempotency expectations
- the failure mode being fixed or the workflow being added
- any existing repo-native test, fixture, sandbox, or replay command

## Steps / Tasks

1. Run `repo-navigator` to locate the current adapter boundary, client wrapper, webhook handler, secret-loading path, and repo-native verification commands.
2. Map the integration direction explicitly: outbound client, inbound webhook, or bidirectional sync.
3. Keep provider-specific logic behind a narrow adapter or handler boundary instead of scattering it across business code.
4. Make request and event contracts explicit. Validate required fields, auth material, signature checks, and error classes at the boundary.
5. Implement retries, backoff, idempotency, dedupe, and timeout behavior intentionally rather than relying on hidden defaults.
6. Add or update tests for auth failure, duplicate delivery, pagination edges, rate-limit behavior, partial sync failure, and malformed provider payloads when those risks exist.
7. Run the repo-native lint, type, test, and fixture or sandbox path that proves the integration behavior locally.
8. Finish with `self-check`.

## Output Contract

Return:
- the provider surface and repo entry point that changed
- the auth, retry, timeout, and idempotency decisions
- the local verification path that ran
- any provider-specific operational risk that remains
- follow-up work only when directly implied by the changed contract

## Tools / Commands

- `rg` for provider names, webhook routes, retry helpers, auth loaders, and fixtures
- repo-native test, lint, type-check, and mock or replay commands
- provider sandbox or local stub commands already defined by the repo
- `git diff -- <path>`

## Dependencies

- `repo-navigator`
- `api-design-reviewer`
- `api-test-suite-builder` or `test-strategy-planner`
- `security-scan` when secrets, signatures, or server-side fetch behavior change
- `self-check`

## Example

Add a webhook consumer for a payment provider that verifies request signatures, rejects duplicate event IDs, retries transient downstream failures safely, and proves the flow with fixture-backed tests.
