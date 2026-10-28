---
name: repo-navigator
description: Safely explore a repository and locate the correct files or modules before making changes
argument-hint: "[task or component]"
disable-model-invocation: false
---

# Skill: repo-navigator

## Purpose
Safely explore a repository before edits, locate the correct files or modules,
extract the patterns the change must match, and recommend the next step.

## Trigger Conditions
Use this skill when:
- locating where a feature, module, config change, or bug fix lives
- tracing how an existing workflow behaves before editing
- mapping repo structure, entry points, tests, or registrations
- identifying the existing patterns another implementation or review step must follow

If multiple plausible edit targets remain, ask clarifying questions before
recommending a file.

## Step Order (Mandatory)
1. Locate the top-level directories, entry points, and likely test or config areas.
2. Narrow to the relevant files with repo-native discovery tools.
3. Read the smallest useful set of files to confirm structure and ownership.
4. Extract the existing patterns the next change must match.
5. If the task is about behavior, switch into feature trace mode.
6. Identify the dependency path and all explicit wiring requirements.
7. Recommend the exact edit target or stop and ask if ambiguity remains.

## Exploration Method
Prefer repo-native discovery tools when available:
- `Glob` to find files by pattern.
- `Grep` to search for symbols, functions, classes, imports, and config keys.
- `Read` to inspect the specific files that establish structure and behavior.

Start from high-level directories and move toward specific modules. Never assume
file locations without checking. Do not run shell commands for discovery when
dedicated repository tools are available.

When the request is about how an existing feature works, switch into feature
trace mode:
- identify the user, API, CLI, config, or scheduler entry points
- follow the call path from trigger to side effect
- note data transformations, async boundaries, and error or fallback paths
- map internal and external dependencies
- identify persistence, emitted events, background work, and state changes
- include file and line references when the evidence supports them

## Evidence Expectations
- Cite the files that established the recommended edit target.
- Call out the patterns, dependency path, and wiring points that must be preserved.
- Surface unresolved ambiguity instead of guessing between multiple viable targets.

## Non-Goals
- Do not modify files in this step.
- Do not jump from a file search straight to implementation without extracting patterns.
- Do not leave wiring implicit when the next step would depend on it.

## Output Format
1. REPOSITORY OVERVIEW

Describe:
- project type (CLI tool, library, agent system, API service, etc.)
- main languages
- major directories and their purpose
- important entry points

2. RELEVANT FILES

Identify the relevant files for the task and explain why each matters.

Format:
`path/to/file.py`
What this file does and why it matters for this task.

3. FEATURE TRACE (WHEN RELEVANT)

Use this section when the user asks how an existing feature, workflow, bug path,
or integration behaves.

Document:
- entry points and triggers
- step-by-step execution flow
- key data transformations
- error and fallback paths
- state changes and side effects
- dependencies that must be understood before editing

Skip this section for simple file-location tasks.

4. EXISTING PATTERNS

Extract the patterns new code must match:
- error handling style
- async pattern
- import style
- schema or model conventions when applicable
- naming conventions
- test style
- how integrations are registered

5. EDIT TARGET

Recommend the correct file or files to modify. If multiple files could fit,
list them and ask which should be used.

6. DEPENDENCY PATH

Explain how the relevant files interact. Make downstream call paths explicit.

7. WIRING REQUIREMENTS

List every place the change must be connected:
- exports or registrations
- config maps or metadata
- downstream consumers
- generated outputs or side-effect readers

8. SAFE NEXT STEP

Recommend the next action, such as:
- move to the appropriate implementation skill
- gather one more clarifying search
- stop because the boundary is still ambiguous
