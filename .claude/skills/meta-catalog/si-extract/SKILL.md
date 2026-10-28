---
name: "si-extract"
description: "Turn a proven pattern or debugging solution into a standalone reusable skill with SKILL.md, reference docs, and examples. Use when: a solution is broadly applicable across projects and worth packaging."
command: /si-extract
---

# Skill: si-extract

## Purpose
Turn a proven recurring pattern into a portable reusable skill package. This is
the command-backed extraction workflow for promoting knowledge into a new skill
boundary rather than a rule.

## Command Alias

Primary command:

```text
/si-extract <pattern description> [--name <skill-name>] [--dry-run]
```

Prefer the command alias when the user explicitly wants a new reusable skill
from a known pattern. Use `self-improving-agent` when the task still needs
review or promotion-vs-extraction routing.

## Trigger Conditions

Use this skill when:
- the pattern is reusable across projects or repositories
- the solution is too large or specialized for a single rule line
- `si-review` or the user identified a recurring solution worth packaging

## Input Boundary

The user may provide:
- a pattern description
- optional target name
- optional dry-run request
- supporting knowledge entries

Inspect only the knowledge and support needed to define:
- the problem
- the trigger conditions
- the reusable solution boundary

## Step Order (Mandatory)

1. Identify the recurring problem, trigger, and solution boundary.
2. Inspect relevant knowledge entries or user-provided examples.
3. Confirm the pattern should become a skill rather than a rule.
4. Choose or validate a lowercase hyphenated skill name.
5. If the request is not `--dry-run`, generate the skill package, using the
   `skill-extractor` agent when a delegated file-generation pass is helpful.
6. Validate the package for frontmatter, portability, and absence of
   project-specific secrets or hardcoded paths.
7. Report the created or proposed structure and any remaining quality gaps.

## Evidence Expectations

- State the source pattern or knowledge entries used for extraction.
- State why the result should be a reusable skill instead of a rule.
- State the proposed or created skill name and directory structure.
- State the portability checks that were applied.

## Non-Goals

- Do not extract omnibus skills that cover multiple unrelated problems.
- Do not include project-specific paths, credentials, or secrets.
- Do not claim extraction is complete without checking frontmatter and
  portability basics.
- Do not mutate unrelated active skills while creating the new package.

## Output Format

1. EXTRACTION DECISION

State the pattern and why it belongs in a skill.

2. SKILL BOUNDARY

State the problem, trigger, and what the new skill must not absorb.

3. PACKAGE PLAN OR RESULT

State the proposed or created files and skill name.

4. QUALITY CHECKS

State the portability and frontmatter checks performed.

5. NEXT STEP

State whether to finalize, refine, or stop.
