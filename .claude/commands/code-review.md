---
name: code-review
description: Multi-language code review. Usage: /code-review <target>
---

# /code-review

Comprehensive code review for any language.

## Usage

```
/code-review src/
/code-review api/routes.ts
/code-review "check authentication logic"
```

## Workflow

### 1. Scope Definition

- Identify files to review
- Determine review depth
- Set focus areas (security, performance, style)

### 2. Analysis

#### Correctness
- Logic errors
- Edge cases
- Error handling

#### Security
- Input validation
- Authentication/authorization
- Data exposure

#### Performance
- N+1 queries
- Unnecessary allocations
- Missing caching

#### Style
- Consistency with codebase
- Naming conventions
- Documentation

### 3. Report

Format findings by severity:

| Severity | Meaning |
|----------|---------|
| 🔴 Critical | Must fix before merge |
| 🟡 Warning | Should fix |
| 🟢 Suggestion | Consider improving |

## Rules

- **BE** specific - quote the code
- **EXPLAIN** why it's a problem
- **SUGGEST** how to fix
- **ACKNOWLEDGE** good patterns
- **CONTEXT** matters - consider architecture

## Skill Chain

Invoke the code-reviewer skill for structured review:

1. **repo-navigator** — locate files and understand patterns
2. **code-reviewer** — perform the review with SOLID analysis
3. **self-check** — validate any fixes applied

For deeper specialist review, add only the matching lane:

- **type-design-analyzer** — API, schema, generic, or type-contract risk
- **pr-test-analyzer** — changed tests, false-green risk, missing regression coverage
- **database-reviewer** — migrations, query behavior, integrity, Postgres
- **performance-optimizer** — latency, throughput, allocation, benchmark risk
- **typescript-reviewer**, **python-reviewer**, **go-reviewer**, **rust-reviewer** — language-specific depth
- **sast-orchestrator** or **dependency-auditor** — security or supply-chain scope

Do not include every specialist by default. Route by the files and risks found
during repo navigation.

## Supported Languages

- Python (PEP8, type hints, asyncio)
- Go (idiomatic, error handling)
- TypeScript/JavaScript (ES2022+, TypeScript patterns)
- Rust (ownership, lifetime hints)
- SQL (query optimization, schema design)
- Shell (bash best practices)
