# E2E Journey Gates

Use these gates when browser-visible behavior needs stronger evidence than a
visual audit or single screenshot.

## Journey Selection

Only promote a flow to E2E when it is worth the maintenance cost:

- authentication and account access
- payment, checkout, booking, or irreversible mutation
- critical CRUD workflow
- search/filter workflow that drives core product value
- previous production regression

Do not create E2E tests for decorative UI or low-risk copy changes.

## Locator And Wait Gate

- Prefer semantic locators and `data-testid` where the repo already uses them.
- Avoid CSS/XPath selectors unless no stable semantic target exists.
- Wait for conditions, navigation, responses, or visible state.
- Do not use fixed sleeps such as `waitForTimeout` as the primary synchronization.
- Keep each test independent; no hidden order dependency.

## Artifact Gate

For failed or high-value E2E runs, retain:

- screenshot or video when supported by the runner
- trace or browser log when supported
- exact command, base URL, viewport, and browser
- failure summary that names the broken user step

For this repo, browser-audit artifacts stay under `/tmp` or ignored artifact
paths unless a task explicitly asks for a committed fixture.

## Flake Gate

When a test is flaky:

- repeat locally enough to confirm instability before changing assertions
- identify whether the cause is timing, network, shared state, animation, or test data
- quarantine only with a reason and a follow-up owner/path
- prefer stable waits and isolated fixtures over retries alone
