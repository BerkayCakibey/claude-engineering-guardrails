---
name: python-quality-review
description: Review Python code for maintainability, readability, structure, and implementation quality
argument-hint: "[file, module, or change to review]"
disable-model-invocation: false
---

# Skill: python-quality-review

## Purpose
Review Python code for maintainability, readability, structure, and testability
without collapsing into generic style commentary.

## Use When
- The user asks for Python code review feedback.
- A Python file, module, diff, or change set needs maintainability review.
- You need evidence-backed findings before accepting or expanding Python code.

## Review Workflow
1. Identify the exact review scope: file, module, diff, or bounded change set.
2. Read enough surrounding code to understand responsibilities and integration
   points.
3. Separate structural issues from style-only preferences.
4. Confirm whether each suspected issue affects readability,
   maintainability, correctness, or testability.
5. Report findings first, then targeted improvements.

## Review Gates
### Readability And Structure
- functions and classes stay small enough to reason about
- naming is clear and consistent with the repo
- modules do not mix unrelated responsibilities

### Change Safety
- new logic fits existing boundaries and does not create hidden coupling
- error handling and state changes are explicit
- constants, configuration, and I/O boundaries are not buried inside core logic

### Testability
- logic can be exercised without excessive hidden globals or hardwired side
  effects
- dependency boundaries are explicit enough for tests
- the testing surface is not harder than the feature requires

## Evidence Contract
- cite concrete file or diff locations for each finding
- explain why the issue matters in practical maintenance terms
- distinguish confirmed issues from optional cleanup ideas

## Output Requirements
```markdown
## Scope
- [file, module, or diff reviewed]

## Findings
- Severity: HIGH | MEDIUM | LOW
- Location: path:line or diff section
- Issue: [concrete maintainability or structure problem]
- Why It Matters: [practical impact]
- Fix Direction: [smallest useful correction]

## Testability Notes
- [what helps or hurts testing]

## Verdict
- [safe to keep, cleanup recommended, or refactor before expansion]
```
