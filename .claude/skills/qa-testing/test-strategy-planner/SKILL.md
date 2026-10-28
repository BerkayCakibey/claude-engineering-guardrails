---
name: test-strategy-planner
description: Design a minimal and effective testing strategy for a codebase, change, or module, including language-specific setup when needed
argument-hint: "[module, change, or project]"
disable-model-invocation: false
---

# Skill: test-strategy-planner

## Purpose
Design the smallest effective test plan for a codebase, change, or module. Use
this broader workflow when the task is larger than a narrow language-specific
testing card and you need to decide what coverage, tooling, and evidence will
actually prove the behavior.

## Trigger Conditions
Use this skill when:
- behavior changed and the right test scope is not obvious yet
- a bug fix, new feature, refactor, or PR needs a minimal but defensible test plan
- you need to choose between unit, integration, browser, or end-to-end coverage
- a language-specific testing skill escalates to a broader or cross-language strategy
- you need to define the evidence that proves the change really worked

If the scope of the testing request is unclear, ask for clarification before
planning tests.

## Step Order (Mandatory)
1. Map the changed behavior, contract, or bug class that the tests must cover.
2. Detect the repo's existing test contract: runner, scripts, harnesses, and CI expectations.
3. Detect async, browser, network, process, or external-system risk when applicable.
4. Choose the smallest test levels that can prove the important behavior.
5. Name the critical test cases, mocking boundaries, and false green risks.
6. Recommend the smallest command set and success signal that prove the change.
7. State what "good enough" coverage means and whether a broader escalation is needed.

## Input Boundary
The user may provide:
- a project or codebase
- a module or service
- a CLI tool or script
- a browser flow or user journey
- an implementation plan
- a diff, PR, or bug description

Use the changed behavior, not the file count, to decide what must be tested.

## Repo And Runtime Detection
Before recommending any tests:
- inspect the existing test directories, test scripts, and CI or local validation commands
- match the repo's current runner, fixture style, and assertion style
- detect whether the risk is pure unit logic, integration behavior, browser runtime, or cross-system flow
- use a language-specific testing card when the question becomes a narrow toolchain decision

### Python Async Detection
When Python and pytest are in scope, this check is mandatory.

Look for:
- `async def` functions in the modules being tested
- existing test files with async markers
- dependencies such as `anyio`, `asyncio`, or `trio`

If async code is present, determine which async library is already in use:
- `asyncio`
- `anyio`
- `trio`

Then match the existing setup:
- For `anyio`, use `@pytest.mark.anyio`; the plugin is bundled with `anyio`.
- For `asyncio`, use `pytest-asyncio` with `@pytest.mark.asyncio`.
- Do not mix `asyncio` and `anyio` markers in the same suite.

For non-Python repos, match the repo's existing runtime and test harness instead
of inventing a new async or concurrency stack.

## Critical Test Areas
List the most important behavior to test, such as:
- input validation and malformed input
- edge cases and boundary values
- error handling and failure paths
- contract changes such as API responses, CLI output, schemas, or generated files
- configuration loading
- data writes, events, jobs, cache invalidation, or network calls
- async, race, browser, or background-work behavior

Also identify the easiest way a false green could happen, such as:
- the new test is not executed
- the assertion checks setup instead of behavior
- a mock replaces the system under test
- an exception is swallowed
- a validator checks file presence but not content or behavior
- a command failure is hidden by shell control flow

For PR or local-commit readiness checks, use
`references/pr-coverage-gates.md` to map changed behavior to coverage gaps and
rate missing tests by the real regression they would catch.

## Test Levels
Recommend only the levels that are actually needed:
- Unit tests for isolated logic and boundary parsing
- Integration tests for component interaction and side effects
- End-to-end or browser tests only when smaller tests cannot prove the critical behavior

Prefer the smallest layer that can catch the real regression.

## Mocking Strategy
Explain what should be isolated and what should remain real:
- mock external services, subprocesses, file writes, or environment variables only where needed
- avoid mocks that hide the behavior under test
- call out cases where a real integration, browser, or runtime check is the safer proof

## Test Execution
Recommend the smallest command set that proves the behavior.

For each command, state:
- what it proves
- what it does not prove
- whether a failing RED state is required before implementation
- what output or exit code should be captured as evidence

Keep execution repo-native and simple.

## Minimum Acceptable Coverage
Describe what "good enough" means for this change:
- core logic covered
- important edge or failure paths covered
- major contracts or side effects verified
- at least one test that would catch the motivating regression

Avoid coverage percentages unless the repo already relies on them.

## Hard Rules
- Do not generate large test suites by default.
- Do not recommend broad E2E coverage unless lower-cost tests cannot prove the behavior.
- Do not introduce a new test runner or async library when the repo already has one.
- Do not confuse language-specific toolchain advice with the broader test-strategy boundary.
- Keep recommendations proportional to the real regression risk.

## Output Format
1. TEST SCOPE

Describe what part of the project is being tested and which behavior matters.

2. TEST CONTRACT

State the repo-native runner, harness, and language or framework assumptions.

3. TEST LEVELS

Identify which levels are needed and why.

4. CRITICAL TEST AREAS

List the must-cover behavior, failure paths, and false-green risks.

5. TEST STRUCTURE

Recommend a simple file or suite layout that matches the repo.

6. MOCKING STRATEGY

Explain what to isolate and what should stay real.

7. TEST TOOLING

Name the minimal tooling required, sticking to what the repo already uses.

8. TEST EXECUTION

List the smallest commands that prove the behavior and the evidence to capture.

9. MINIMUM ACCEPTABLE COVERAGE

State what "good enough" looks like and whether broader coverage is justified.

## References
- PR readiness and gap severity: [references/pr-coverage-gates.md](references/pr-coverage-gates.md)
