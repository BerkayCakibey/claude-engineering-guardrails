---
name: self-check
description: Perform a final validation pass after code or configuration changes
argument-hint: "[code or change]"
disable-model-invocation: false
---

# Skill: self-check

## Purpose
Perform a final verification pass after code or configuration changes so logic
mistakes, wiring gaps, weak evidence, and false-green outcomes are caught before
the task is considered complete.

## Trigger Conditions
Use this skill when:
- implementation is complete
- a code, config, or automation change needs final review
- the user asks whether the delivered result is actually ready
- multiple files or systems were touched and a missed integration detail would matter

## Step Order (Mandatory)
1. Compare the delivered change against the stated task or acceptance criteria.
2. Check the logic, edge cases, and failure paths.
3. Verify wiring, registrations, exports, and downstream consumers.
4. Run a pipeline completeness check when data or agent chains are involved.
5. Check consistency against the surrounding codebase patterns.
6. Review test coverage and name the missing tests if they are absent.
7. Check whether the evidence actually proves the changed behavior.
8. Run the SILENT FAILURE CHECK.
9. Return `PASS`, `PASS WITH WARNINGS`, or `REQUIRES FIXES`.

## Required Inputs
The user may provide:
- code changes
- repository diff
- feature implementation
- infrastructure configuration
- a task description to compare against

When a task description is available, compare the implementation against it
explicitly.

## Evidence Expectations
- Name the commands, validators, or tests that were run.
- Say what each signal proves and what it does not prove.
- Downgrade the result when evidence is partial, skipped, or indirect.
- Separate verified behavior from inference or assumption.

## Non-Goals
- Do not modify files in this step.
- Do not mark `PASS` unless the evidence check supports it.
- Do not skip the wiring check or pipeline completeness check when they apply.

## Output Format
1. CHANGE SUMMARY

Explain briefly what changed and whether it addresses the stated goal.

2. LOGIC CHECK

Evaluate whether the implementation logically solves the intended problem.

Check:
- does the code do what the task requires
- are there wrong conditions, incorrect assumptions, or missing edge cases
- is the happy path correct
- is there dead code or an unreachable branch

3. WIRING CHECK

Verify that new or changed components are properly connected to the rest of the
codebase.

Check:
- imports and exports
- registrations and routers
- event, config, or metadata wiring
- downstream consumers that must read new output

4. PIPELINE COMPLETENESS CHECK

If the change involves a data pipeline or agent chain:
- trace the full data flow from source to sink
- verify every stage that writes data has a corresponding stage that reads it
- verify every stage that reads data has a fallback for missing data
- check that all intermediate results are persisted or passed correctly

5. CONSISTENCY CHECK

Verify that the change matches surrounding repository patterns:
- naming
- error handling
- async model
- import style
- test style
- schema or model conventions

6. TEST COVERAGE

Verify that the change is tested and that the tests cover the happy path plus at
least one failure or edge path when appropriate.

7. EVIDENCE CHECK

Verify that the success signal proves the requested behavior.

Check:
- which commands were run and whether their exit codes were observed
- whether generated files were compared against regenerated output
- whether validators check behavior, not only file presence
- whether test output includes the affected test or module
- whether warnings, partial runs, skipped tests, or suppressed errors were ignored
- whether a pass could be a false green because the target was not exercised

If evidence is partial, downgrade to `PASS WITH WARNINGS` or `REQUIRES FIXES`.

8. SILENT FAILURE CHECK

Look specifically for:
- swallowed exceptions
- ignored return values
- empty catch or except blocks
- redirected or suppressed command output
- tests without meaningful assertions
- mocks that only verify mock behavior
- scripts that continue after failed validation

Flag each issue with the affected file and the smallest useful fix.

9. FINAL STATUS

Return one of:

`PASS`
No issues found and the evidence is strong enough to proceed.

`PASS WITH WARNINGS`
Minor issues or untested areas remain, but they do not block progress.

`REQUIRES FIXES`
One or more issues must be resolved before the task is complete.
