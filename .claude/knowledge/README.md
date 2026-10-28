# Knowledge Store

This directory stores project knowledge files used by the self-improving skill loop (si-remember, si-review, si-promote, si-extract, si-status).

Knowledge entries are markdown files organized by topic. Each file contains distilled insights, proven patterns, and debugging notes that persist across sessions.

## File Naming

- Use kebab-case: `python-async-patterns.md`, `k8s-debugging.md`
- One topic per file
- Keep files under 200 lines; split when they grow

## Lifecycle

- **si-remember** saves new knowledge here
- **si-review** audits entries for staleness and promotion candidates
- **si-promote** graduates proven entries to `.claude/rules/` or `CLAUDE.md`
- **si-status** reports file counts and capacity