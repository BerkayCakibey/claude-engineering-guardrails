---
name: bugfix-root-cause-analyzer
description: Analyze Python errors or failures and determine the likely root cause and fix strategy
argument-hint: "[error, traceback, or failing behavior]"
disable-model-invocation: false
---

# Skill: bugfix-root-cause-analyzer

## Purpose
Diagnose a failing behavior, traceback, or error report and determine the most
likely root cause before code changes begin. Use this workflow to narrow the
problem, explain the evidence, and recommend the safest fix direction.

## Trigger Conditions
Use this skill when:
- a bug report includes an error message, traceback, failing output, or broken behavior
- a failing test needs diagnosis before implementation
- the engineer needs root-cause analysis rather than an immediate rewrite
- a broader bugfix workflow needs the failure narrowed before editing

If the failure context is incomplete, ask clarifying questions before
diagnosing.

## Input Boundary
The user may provide:
- a traceback
- an error message
- failing program output
- unexpected behavior description
- logs
- a code snippet
- a failing test

Prefer concrete failure evidence over speculation. If multiple data sources
conflict, call that out explicitly.

## Step Order (Mandatory)
1. Restate the failure in concrete terms.
2. Identify the most relevant frame, module, or subsystem involved.
3. Explain what the error means in the local runtime context.
4. Form the most likely root-cause hypothesis from the available evidence.
5. List materially plausible alternative causes only when they fit the evidence.
6. Recommend the smallest diagnostic steps that can confirm or falsify the hypothesis.
7. Propose the safest fix strategy without expanding into an unnecessary rewrite.

## Evidence Expectations
- Identify the exception type, failing module, and most relevant file or line when available.
- Explain why the proposed root cause fits the evidence better than alternatives.
- Distinguish confirmed facts from inference.
- If the failure report is too incomplete for a confident call, say so and request the missing evidence.

## Non-Goals
- Do not jump straight into implementation before explaining the cause.
- Do not guess when the evidence is missing or contradictory.
- Do not propose broad rewrites when a bounded fix is more likely.
- Do not hide uncertainty behind generic debugging advice.

## Output Format
1. PROBLEM SUMMARY

Briefly explain what appears to be happening.

2. ERROR INTERPRETATION

Identify:
- the exact exception or failure class
- the file, line, or subsystem involved when known
- the frame or signal that matters most

3. LIKELY ROOT CAUSE

State the most likely cause and explain the reasoning.

4. ALTERNATIVE CAUSES

List only the alternatives that materially fit the evidence and explain what
would make each one true.

5. DIAGNOSTIC STEPS

Suggest the smallest checks that would confirm the hypothesis, such as:
- printing or logging intermediate values
- inspecting variable types
- validating API responses
- checking configuration values
- verifying file existence or environment inputs

6. FIX STRATEGY

Explain the safest bounded fix direction before writing code.

7. OPTIONAL IMPLEMENTATION

Only if requested, provide a small code change that resolves the issue.

## Hard Rules
- Prefer evidence over intuition.
- Prefer minimal fixes over broad rewrites.
- Keep the analysis focused on the real failure, not nearby style issues.
