---
name: python-project-planner
description: Turn a Python tool or project idea into a clear implementation plan and repository structure
argument-hint: "[project idea]"
disable-model-invocation: false
---

# Skill: python-project-planner

## Purpose
Turn a Python idea into an approval-ready project plan with minimal viable
architecture, repository structure, phased implementation, and early risk
awareness.

## Trigger Conditions

Use this skill when:
- the user has a Python tool, service, automation, or library idea
- the work still needs scope definition before implementation
- the repository structure and implementation phases are not yet decided

## Input Boundary

The user may provide:
- a project idea
- a problem to solve
- a script, CLI, service, automation, or AI-tool concept
- expected users or outputs

If the request is too vague to choose a project type or MVP scope, ask for the
minimum clarification needed before planning.

## Step Order (Mandatory)

1. Restate the project idea and identify the problem, user, and expected
   output.
2. Define the MVP scope, nice-to-have scope, and explicit out-of-scope items.
3. Choose the project type that best fits the idea.
4. Propose the smallest workable repository structure.
5. Break the design into modules with clear responsibilities.
6. Suggest only the dependencies that are actually needed.
7. Produce phased implementation steps and call out early risks.
8. Hand off to `python-implementation-planner` for the concrete build plan.

## Evidence Expectations

- State the project type and why it fits.
- State the proposed repository structure and module responsibilities.
- State the biggest risks or unknowns that should be tested early.
- Keep the plan small enough to be approved before code is written.

## Non-Goals

- Do not start implementing code.
- Do not invent heavy architecture for a small MVP.
- Do not add dependencies that the scope does not justify.
- Do not blur the line between plan approval and implementation.

## Output Format

1. PROJECT UNDERSTANDING

State the idea, user, and expected output.

2. SCOPE DEFINITION

State MVP scope, nice-to-have scope, and out-of-scope items.

3. PROJECT TYPE

State the chosen type and why.

4. REPOSITORY STRUCTURE

State the proposed layout and packaging/tooling assumptions.

5. MODULE BREAKDOWN

State the main modules and their responsibilities.

6. DEPENDENCIES

State only the necessary dependencies.

7. IMPLEMENTATION PHASES

State the phased development order.

8. RISKS AND UNKNOWNS

State what must be validated early.

9. NEXT STEP

State the handoff to `python-implementation-planner`.
