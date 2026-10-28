---
description: Start a Go development task -- routes through the Go skill chain
argument-hint: "[task description]"
---

# Go Task

Entry point for Go development work.

## Step 1: Route the task

Use the Skill tool to invoke task-dispatcher:
- skill: task-dispatcher
- Pass the full task description from the user argument (`$ARGUMENTS`)

## Step 2: Follow the skill chain

### Go development (most common)

CORE:

1. Invoke `repo-navigator` -- locate relevant files and understand module structure
2. Invoke `golang-pro` -- implement with Go expertise (concurrency, interfaces, generics)
3. Invoke `self-check` -- verify logic, wiring, and consistency
4. If self-check returns REQUIRES FIXES: fix issues, re-run self-check until PASS

Additional skills (test-strategy-planner, code-reviewer) only when task-dispatcher includes them.

### Go debugging

1. Invoke `repo-navigator` -- locate the failing code
2. Use debugger agent -- investigate root cause (race conditions, panics, goroutine leaks)
3. Invoke `golang-pro` -- implement the fix
4. Invoke `self-check` -- verify the fix

## Rules

- Never skip repo-navigator when working in an existing codebase
- Always run self-check after implementation
- Use `go build ./...`, `go vet ./...`, `go test ./...` for validation
- Use `-race` flag when testing concurrent code
