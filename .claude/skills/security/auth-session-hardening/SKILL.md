---
name: auth-session-hardening
description: Harden login, session, cookie, token, and authorization flows with explicit trust boundaries, secure defaults, and regression-proof verification.
domain: security_trust
role: execute_build
scope: bounded_task
power: local_repo_mutation
---

# Skill: auth-session-hardening

## Purpose / Use When

Use this skill when:
- tightening login, logout, refresh, session, or token handling
- fixing weak cookie, JWT, CSRF, or role-enforcement defaults
- reducing trust in client-only authorization paths
- implementing a minimal, concrete auth hardening change rather than a broad audit

## When Not to Use

Do not use this skill when:
- the task is a broad security review with no implementation step; use `security` or `security-scan`
- the task is identity-provider selection or long-range auth architecture planning
- the task requires production secret rotation or live incident handling
- the current auth boundary cannot be identified from the repo

## Input Expectation

Provide:
- the auth mechanism in use, if known
- affected routes, middleware, or session stores
- acceptance criteria or known weakness
- session lifetime, refresh, role, or cookie constraints
- any relevant test or repro path

## Steps / Tasks

1. Run `repo-navigator` to map login, logout, refresh, middleware, session storage, and privileged routes.
2. Identify the first boundary where the application starts trusting identity or session state.
3. Tighten the smallest set of defaults needed: cookie flags, token validation, expiry, rotation, CSRF handling, audience or issuer checks, and server-side role enforcement.
4. Remove ambiguous fallback paths, broad allow lists, and client-only authorization decisions.
5. Add or update negative-path tests for expired, revoked, forged, or downgraded identities.
6. Run repo-native verification, then use `security-scan` or the `security` agent if the user also asked for review findings.
7. Finish with `self-check`.

## Output Contract

Return:
- the trust boundary that was hardened
- the concrete default or policy changes
- the negative-path verification that ran
- any remaining auth risks that were out of scope
- follow-up work only when directly implied by the changed boundary

## Tools / Commands

- `rg -n "auth|session|jwt|csrf|cookie|middleware|authorize|role|refresh"`
- repo-native test and lint commands
- `git diff -- <path>`

## Dependencies

- `repo-navigator`
- `security-scan`
- `test-strategy-planner`
- `self-check`

## Example

Tighten a cookie-backed session flow by enforcing `HttpOnly`, `Secure`, and explicit `SameSite`, moving the admin role check to the server boundary, and adding tests for expired and downgraded sessions.
