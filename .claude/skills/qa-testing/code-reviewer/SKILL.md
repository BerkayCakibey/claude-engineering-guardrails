---
name: "code-reviewer"
description: Code review automation for TypeScript, JavaScript, Python, Go, Swift, Kotlin. Analyzes PRs for complexity and risk, checks code quality for SOLID violations and code smells, generates review reports. Use when reviewing pull requests, analyzing code quality, identifying issues, generating review checklists.
---

# Code Reviewer

Use this skill to run a structured code review workflow with repeatable local
analysis, then turn those results into evidence-backed findings. Keep the main
skill focused on orchestration. Treat the scripts as helpers, not as a
substitute for human source inspection.

## When To Use

- The user explicitly asked for a code review.
- You need diff-aware risk triage before reading the changed files in depth.
- You need a repeatable quality scan or a review artifact for a repository.
- Another workflow calls for a structured review pass before completion.

## Do Not Use When

- The task is implementation or refactoring rather than review.
- The task is only security-specific scanning. Pair with `security-review`,
  `security-scan`, or the relevant SAST skill when needed.
- There is no repository or diff context to inspect.
- You need final human findings but have not yet checked the source directly.

## Workflow

1. Choose the review scope:
   - diff or PR complexity review
   - structural quality scan
   - combined report
2. Run the smallest useful helper first.
   - `pr_analyzer.py` for branch or commit comparison
   - `code_quality_checker.py` for file or directory quality signals
   - `review_report_generator.py` when you need a consolidated report
3. Inspect the flagged files and confirm whether the findings are real.
4. Convert confirmed issues into reviewer language with severity, evidence, and
   file references.
5. Use the bundled references to check language-specific standards and review
   gates before finalizing the report.

## Script Entry Points

PR complexity and risk analysis:

```bash
python3 scripts/pr_analyzer.py /path/to/repo
python3 scripts/pr_analyzer.py . --base main --head feature-branch --json --output /tmp/pr-analysis.json
```

Code quality scan:

```bash
python3 scripts/code_quality_checker.py /path/to/code
python3 scripts/code_quality_checker.py . --language python --json --output /tmp/quality.json
```

Combined report generation:

```bash
python3 scripts/review_report_generator.py /path/to/repo
python3 scripts/review_report_generator.py . --format markdown --output /tmp/review.md
python3 scripts/review_report_generator.py . --pr-analysis /tmp/pr-analysis.json --quality-analysis /tmp/quality.json
```

## Artifact And Output Locations

- All three scripts print to stdout by default.
- `--json` produces machine-readable output for downstream tooling.
- `--output <path>` writes the analysis or report to a task-selected location.
- Recommended task-local artifact paths look like:
  - `/tmp/code-reviewer/pr-analysis.json`
  - `/tmp/code-reviewer/quality.json`
  - `/tmp/code-reviewer/review.md`
- Only write repo-local review artifacts when the task explicitly calls for
  checked-in review output.

## Validation Path

- `python3 scripts/pr_analyzer.py --help`
- `python3 scripts/code_quality_checker.py --help`
- `python3 scripts/review_report_generator.py --help`
- Run at least one helper against the target repository or diff and confirm the
  output shape before relying on it in the review.

## Non-Goals And Safety Notes

- Do not treat heuristic script output as a confirmed issue without source
  inspection.
- Do not approve, block, or request changes from the aggregate score alone.
- Do not mutate source code inside the review pass unless the user asked for a
  fix workflow after the review.
- Do not collapse correctness, performance, security, and maintainability into
  a generic comment when the issue needs a sharper category.

## Support Assets

- [scripts/pr_analyzer.py](scripts/pr_analyzer.py) - diff and commit risk
  triage
- [scripts/code_quality_checker.py](scripts/code_quality_checker.py) -
  structural quality scan
- [scripts/review_report_generator.py](scripts/review_report_generator.py) -
  consolidated review report generator
- [references/code_review_checklist.md](references/code_review_checklist.md) -
  core review checklist
- [references/coding_standards.md](references/coding_standards.md) -
  language-specific standards
- [references/common_antipatterns.md](references/common_antipatterns.md) -
  anti-pattern catalog
- [references/backend_service_gates.md](references/backend_service_gates.md) -
  backend review gates
- [references/type_design_gates.md](references/type_design_gates.md) -
  type and contract review gates
