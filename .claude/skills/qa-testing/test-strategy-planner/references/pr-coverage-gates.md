# PR Coverage Gates

Use these gates when reviewing whether a change has enough tests before a PR or
local commit is considered ready.

## Changed Behavior Map

Map the diff to changed behavior before judging coverage:

- changed functions, classes, handlers, commands, or workflows
- new validation, auth, permission, or error paths
- new side effects such as writes, events, jobs, cache invalidation, or network calls
- changed contracts such as API responses, CLI output, schemas, or generated files

Tests should cover behavior and contracts, not incidental implementation details.

## Gap Severity

Rate missing tests by the bug they would prevent:

- Critical: data loss, auth bypass, security issue, irreversible mutation, deploy blocker
- Important: user-facing behavior, business rule, cross-module integration, async/race path
- Nice-to-have: low-risk edge case, readability, or refactor confidence

Do not ask for broad coverage just to improve a number. Ask for the smallest test
that would catch the real regression.

## Test Quality Gate

Flag tests that:

- only assert no exception without checking the changed behavior
- mock the system under test so thoroughly that the real behavior is not exercised
- check implementation details that can change without breaking the contract
- skip the failure path that motivated the fix
- can pass if the new code is never executed

For every important recommendation, state what failure the test would catch.

## E2E Escalation Gate

Recommend end-to-end tests only when unit or integration tests cannot prove the
critical behavior. E2E is appropriate for:

- auth, payment, signup, checkout, or other critical user journeys
- multi-step browser workflows
- cross-service flows where mocking would hide the risk
- regressions that only appear in the rendered UI or browser runtime

Prefer existing Playwright, Cypress, or browser-audit tooling over adding another
browser stack.
