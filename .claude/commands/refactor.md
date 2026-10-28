---
name: refactor
description: Large-scale code refactoring with safety. Usage: /refactor <target> <goal>
---

# /refactor

Structured refactoring workflow for large-scale code changes.

## Usage

```
/refactor "src/auth/" "extract to separate module"
/refactor "api/*" "add error handling"
/refactor "models.py" "apply single responsibility"
```

## Workflow

### Phase 1: Analyze

1. **Understand Current Code**
   - Map dependencies
   - Identify side effects
   - Find all usage sites

2. **Plan Refactoring**
   - Break into smallest possible steps
   - Order by dependency
   - Identify test points

### Phase 2: Prepare

1. **Ensure Tests Exist**
   - If no tests, write them first
   - Verify tests pass before refactoring
   - Set baseline coverage

2. **Create Backup Point**
   - If your workflow uses Git checkpoints, create a user-approved backup point
   - Use the lightest rollback marker your environment supports

### Phase 3: Execute

1. **Smallest Change First**
   - One logical change per step
   - Run tests after each step
   - Add user-approved checkpoints only when your workflow needs them

2. **Validate Continuously**
   - Tests must pass at each step
   - No performance regression
   - No behavior change

### Phase 4: Complete

1. **Final Review**
   - All tests pass
   - Coverage maintained or improved
   - No new linter warnings

2. **Document Changes**
   - Update comments
   - Update relevant docs
   - Explain "why" in commit message

## Rules

- **NEVER** refactor without tests
- **ALWAYS** keep refactoring separate from feature changes
- **ONE** logical change per reviewable step
- **SMALL** steps over big-bang changes
- **TEST** after every change
- **STOP** if tests fail, fix the issue, and use a user-approved rollback only when needed

## Skill Chain

For medium+ effort tasks, invoke skills in order:

1. **repo-navigator** — locate files, understand structure before changes
2. **refactor-rules** — apply refactoring policy (scope control, rollback)
3. **self-check** — validate changes after each step

For high-effort tasks, add:
4. **code-reviewer** — review before finalizing
5. **tdd-guide** — ensure test coverage maintained

Use **task-dispatcher** to identify additional skills for the specific refactoring target.

## Anti-Patterns to Avoid

- ❌ Renaming variables while changing logic
- ❌ Moving code while modifying it
- ❌ Deleting dead code that isn't dead
- ❌ "We'll clean it up later"
