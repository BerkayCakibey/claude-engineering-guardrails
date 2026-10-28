---
description: Investigate and fix a bug using root cause analysis
argument-hint: "[error, traceback, or bug description]"
---

# Bug Fix

Entry point for bug investigation and fixes.

## Step 1: Locate the failing code

Use the Skill tool to invoke repo-navigator:
- skill: repo-navigator
- Prompt: locate the code related to `$ARGUMENTS`

## Step 2: Analyze root cause

Use the Skill tool to invoke bugfix-root-cause-analyzer:
- skill: bugfix-root-cause-analyzer
- Pass the error or traceback and the files identified in Step 1

Wait for the analyst to produce a diagnosis and fix strategy.
Do not implement until the root cause is identified.

## Step 3: Implement the fix

Use the implementation skill or specialist agent that matches the affected
surface:

- Python: python-code-implementer
- Node.js / TypeScript: node-implement
- Go: golang-pro
- Security bug: security plus sast-orchestrator
- Test confidence bug: pr-test-analyzer or silent-failure-hunter before editing

Implement only the fix defined in Step 2. Do not change unrelated code.

## Step 4: Verify

Use the Skill tool to invoke self-check:
- skill: self-check
- Verify the fix is correct, complete, and consistent

If self-check returns REQUIRES FIXES: fix the issues and re-run self-check.

## Rules

- Never implement before the root cause is confirmed
- Fix only the identified issue — do not expand scope
- Always run self-check after the fix
- Add or update a regression check when the bug class can silently return
