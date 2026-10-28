---
description: Start a Node.js/TypeScript development task -- routes through the Node skill chain
argument-hint: "[task description]"
---

# Node Task

Entry point for JavaScript, TypeScript, and Node.js development work.

## Step 1: Route the task

Use the Skill tool to invoke task-dispatcher:
- skill: task-dispatcher
- Pass the full task description from the user argument (`$ARGUMENTS`)

## Step 2: Follow the skill chain

### Node.js development (most common)

CORE:

1. Invoke `repo-navigator` -- locate relevant files and detect repo contract (package manager, toolchain)
2. Invoke `node-implement` -- detect toolchain, implement change, run quality gates
3. Invoke `self-check` -- verify wiring and consistency
4. If self-check returns REQUIRES FIXES: fix issues, re-run self-check until PASS

Additional skills (test-strategy-planner, code-reviewer) only when task-dispatcher includes them.

### Frontend build

1. Invoke `node-implement` -- implement components
2. Invoke `browser-audit` -- visual QA across viewports
3. Invoke `self-check` -- validate

### Node.js debugging

1. Invoke `repo-navigator` -- locate the failing code
2. Use debugger agent -- investigate root cause
3. Invoke `node-implement` -- implement the fix
4. Invoke `self-check` -- verify the fix

## Rules

- Detect the repo's package manager before editing -- never assume npm
- Follow the repo's existing scripts and conventions
- Always run self-check after implementation
