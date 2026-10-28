# Python development workflow rules

The broader effort protocol is repo-specific. If your setup also uses
`workflow.md`, treat it as a CloudOps or infra-operations rule. This file only
adds the Python-specific skill chains and coding standards.

## Skill chain

### low effort
No skills required. Answer directly.

### medium effort (CORE chain)
1. **repo-navigator** — understand existing code structure, find relevant files
2. **python-dev-preflight** — verify environment (Python version, venv, dependencies)
3. **python-implementation-planner** — generate implementation plan from design
4. **python-code-implementer** — implement changes incrementally
5. **self-check** — validate implementation completeness and wiring

### high effort (FULL chain)
CORE chain + additional skills as needed:
6. **python-quality-review** — code quality assessment (SOLID violations, code smells)
7. **python-security-review** — security risk identification
8. **test-strategy-planner** — design test strategy for new code
9. **tdd-guide** — generate tests if needed

Use **task-dispatcher** to identify additional skills for high-effort tasks.

## Skill usage rules

1. repo-navigator before writing code in an existing codebase.
2. Implementation plan before implementation (medium+ effort).
3. self-check after implementation.
4. At least one review skill before marking high-effort tasks complete.
5. Async codebases: test-strategy-planner must detect async setup before tests.

## Code style

- Follow PEP 8 with type hints on all function signatures.
- Use `pathlib.Path` instead of `os.path` for file operations.
- Use f-strings for string formatting (Python 3.8+).
- Prefer `from __future__ import annotations` for forward references.
- Use `pydantic` or `dataclasses` for data models — no bare dictionaries for structured data.

## Dependency management

- Use `uv` for package management when available.
- Pin exact versions in requirements.txt or pyproject.toml.
- Never add a dependency without checking if an existing one provides the same functionality.
- Document why each dependency exists in a comment or in pyproject.toml metadata.

## Testing

- Write tests for all new functions and classes.
- Test file structure mirrors source: `tests/test_foo.py` for `src/foo.py`.
- Use `pytest` with `pytest-asyncio` for async tests.
- Minimum 80% coverage for new code.
- Always test error paths, not just happy paths.

## Error handling

- Use specific exception types, never bare `except:`.
- Always close resources with context managers (`with` statement).
- Log errors with context — include the operation that failed and relevant parameters.
- Never silently swallow exceptions.

## Self-check failure loop

When self-check returns REQUIRES FIXES:
1. Fix → re-run self-check → repeat until PASS.
2. Only proceed to tests/review after self-check passes.

## Scope control

Use the active task instructions or your repo-specific scope rule. Not repeated
here.

## Before committing

1. Run `ruff check --fix` and `ruff format`.
2. Run `pytest` and ensure all tests pass.
3. Run `python-code-implementer` self-check or manual self-check.
4. Verify no secrets or credentials in staged files.
