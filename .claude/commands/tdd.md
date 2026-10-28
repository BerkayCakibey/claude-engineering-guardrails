---
name: tdd
description: Generate tests, analyze coverage, and run TDD workflows. Usage: /tdd <generate|coverage|validate> [options]
---

# /tdd

Generate tests, analyze coverage, and validate test quality using the TDD Guide skill.

## Usage

```
/tdd generate <file-or-dir>     Generate tests for source files
/tdd coverage <test-dir>        Analyze test coverage and gaps
/tdd validate <test-file>       Validate test quality (assertions, edge cases)
```

## Examples

```
/tdd generate src/auth/login.ts
/tdd coverage tests/ --threshold 80
/tdd validate tests/auth.test.ts
```

## Skill Chain

1. Invoke `repo-navigator` — locate the source, tests, framework, and existing test patterns.
2. Invoke `test-strategy-planner` — choose the smallest useful test set and coverage target.
3. Invoke `tdd-guide` — generate, analyze, or validate tests using the selected mode.
4. Confirm the RED signal when changing behavior: the affected test must compile/run and fail for the intended reason, not because of broken setup.
5. Run the repo-native test command for the affected package or module after the implementation.
6. Confirm the GREEN signal: the same target now passes and actually exercises the changed behavior.
7. Invoke `self-check` — confirm assertions, edge cases, silent-failure risks, and command output before finishing.

Do not create broad test suites before `repo-navigator` identifies the local conventions.
Do not treat a green command as evidence unless it includes the affected test or module.

## Scripts
- `.claude/skills/qa-testing/tdd-guide/scripts/test_generator.py` — Test case generation (library module)
- `.claude/skills/qa-testing/tdd-guide/scripts/coverage_analyzer.py` — Coverage analysis (library module)
- `.claude/skills/qa-testing/tdd-guide/scripts/tdd_workflow.py` — TDD workflow orchestration (library module)
- `.claude/skills/qa-testing/tdd-guide/scripts/fixture_generator.py` — Test fixture generation (library module)
- `.claude/skills/qa-testing/tdd-guide/scripts/metrics_calculator.py` — TDD metrics calculation (library module)

> **Note:** These scripts are library modules without CLI entry points. Import them in Python or use via the SKILL.md workflow guidance.

## Skill Reference
→ `.claude/skills/qa-testing/tdd-guide/SKILL.md`
