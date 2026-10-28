---
name: git-pr-packager
description: Prepare a safe Git workflow and PR summary for any approved change (infrastructure, Python dev, configuration)
argument-hint: "[short change description]"
disable-model-invocation: false
---

# Skill: git-pr-packager

## Purpose
Prepare a safe Git handoff for an already approved change: branch naming,
commit staging guidance, commit message, and PR description. Use this skill
only when packaging work is explicitly requested or already approved.

## Trigger Conditions
Use this skill when:
- the user explicitly asks for commit or PR packaging
- a workflow explicitly requires a manual handoff summary after validation
- the change is ready for a clean Git branch, commit, and PR description

Do not invoke this skill automatically when repo policy or task routing says
the user handles push and PR steps themselves.

## Input Boundary
The user may provide:
- a short change description
- repository context
- changed files
- environment
- risk notes

If the approved scope or changed file set is unclear, ask before packaging.

## Step Order (Mandatory)
1. Confirm the approved change scope and the files that belong in it.
2. Summarize the change and the relevant risk surface.
3. Prepare the minimal Git sequence for branch creation, staging, review, and commit.
4. Draft a single-line commit message.
5. Draft a plain-text PR description for manual use on GitHub.
6. Add tool-specific packaging notes only when the change type justifies them, such as Terraform formatting.

## Evidence Expectations
- State the affected files or file groups.
- State the affected environment when relevant.
- State the real risks only, not generic boilerplate.
- State the verification steps that were already run or still need to be included in the PR body.

## Non-Goals
- Do not expand the change scope beyond what was approved.
- Do not push automatically.
- Do not propose unrelated cleanup work.
- Do not suggest direct work on the main branch.
- Do not override repo policy that excludes automatic `git-pr-packager` routing.

## Output Format
1. CHANGE SUMMARY

Provide:
- short PR title
- short summary
- affected files
- affected environment

2. RISK SUMMARY

List only the relevant risks for this change.

3. GIT WORKFLOW

Provide the minimal Git sequence:
- `git checkout -b <branch-name>`
- `git add <files>`
- `git diff`
- `git commit`

Never include a push step unless the user explicitly asks for it.

4. COMMIT MESSAGE

Provide a single-line commit message. Prefer conventional commit style when it
improves clarity:
- `feat(scope): short description`
- `fix(scope): short description`
- `chore(scope): short description`
- `docs(scope): short description`

5. PR DESCRIPTION

Provide a plain-text PR body with:
- Summary
- Files changed
- Environment
- Risk
- Verification

6. TOOL-SPECIFIC NOTES

Only when relevant, provide bounded packaging notes such as:
- Terraform changes -> recommend `terraform fmt`

Do not require heavier validation tools unless the user explicitly asks for them.
