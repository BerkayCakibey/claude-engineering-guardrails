---
name: "tdd-guide"
description: "Test-driven development skill for writing unit tests, generating test fixtures and mocks, analyzing coverage gaps, and guiding red-green-refactor workflows across Jest, Pytest, JUnit, Vitest, and Mocha. Use when the user asks to write tests, improve test coverage, practice TDD, generate mocks or stubs, or mentions testing frameworks like Jest, pytest, or JUnit. Handles test generation from source code, coverage report parsing (LCOV/JSON/XML), quality scoring, and framework conversion for TypeScript, JavaScript, Python, and Java projects."
---

# TDD Guide

## Overview

Use this skill when the user explicitly wants TDD, targeted test generation,
coverage-gap analysis, or test-quality validation. Keep `SKILL.md`
orchestration-focused. The scripts in this directory are library modules, not
CLI entry points, so use them through the guided workflow or by importing them
from Python.

## When To Use

- The user explicitly asks for a TDD approach.
- The task needs test scaffolding from source code or requirements.
- The task needs coverage-gap analysis from LCOV, JSON, or XML reports.
- The task needs fixture generation, framework adaptation, or TDD phase guidance.
- The `/tdd` command or a review workflow routes here after `repo-navigator`
  and `test-strategy-planner`.

## Do Not Use When

- You only need high-level coverage planning. Use `test-strategy-planner`.
- The repo structure or affected module is still unclear. Use `repo-navigator`.
- The task is browser, performance, or security testing rather than unit or
  integration-focused TDD support.
- The user did not ask for TDD and only needs ordinary implementation validation.

## Workflow

1. Let `repo-navigator` identify the local source, test layout, and framework.
2. Let `test-strategy-planner` define the smallest useful test target and
   evidence threshold.
3. Choose one TDD mode:
   - generate tests
   - analyze coverage gaps
   - validate or guide RED/GREEN/REFACTOR flow
4. Use the relevant library modules in this directory to draft or analyze
   outputs.
5. Confirm the RED and GREEN signals with the repo-native test command when
   behavior changes.
6. Finish with `self-check` before treating generated tests or metrics as final.

## Script Entry Points

These scripts are library modules without standalone CLI entry points.

- `scripts/test_generator.py` - generate test cases and stubs from
  requirements, code, or API specs
- `scripts/coverage_analyzer.py` - parse LCOV, JSON, or XML coverage reports
  and identify gaps
- `scripts/tdd_workflow.py` - guide and validate RED/GREEN/REFACTOR phases
- `scripts/fixture_generator.py` - generate fixtures and mock data
- `scripts/metrics_calculator.py` - calculate test and quality metrics
- `scripts/framework_adapter.py` - map patterns between supported frameworks
- `scripts/format_detector.py` - detect language, framework, and report format
- `scripts/output_formatter.py` - format results for CLI or structured output

Use `/tdd` or the surrounding workflow to decide which modules matter for the
task. Do not treat these scripts as an excuse to skip local test execution.

## Artifact And Output Locations

- Sample inputs and outputs live under `assets/`, including:
  - `assets/sample_input_python.json`
  - `assets/sample_input_typescript.json`
  - `assets/sample_coverage_report.lcov`
  - `assets/expected_output.json`
- Long framework and CI guidance lives under `references/`.
- Task-specific generated tests, reports, or fixtures should go in the target
  repo or a task-local temp path, not inside this skill directory.

## Validation Path

- `python3 -m py_compile .claude/skills/tdd-guide/scripts/*.py`
- Run the repo-native test command for the affected package, module, or suite.
- For behavior changes, confirm the intended RED failure before implementation
  and the matching GREEN pass after it.

## Non-Goals And Safety Notes

- Do not generate broad test suites before local conventions are known.
- Do not treat generated tests as finished proof until they are executed.
- Do not introduce a new framework or coverage tool when the repo already has one.
- Do not replace `test-strategy-planner` with raw script output.
- Do not treat unit-test automation as a substitute for browser, performance,
  or security testing workflows.

## Support Index

- TDD best practices: [references/tdd-best-practices.md](references/tdd-best-practices.md)
- Framework guidance: [references/framework-guide.md](references/framework-guide.md)
- CI integration: [references/ci-integration.md](references/ci-integration.md)
- Extended usage: [HOW_TO_USE.md](HOW_TO_USE.md)
- Maintainer overview: [README.md](README.md)
