---
name: architecture-decision-records
description: "Comprehensive patterns for creating, maintaining, and managing Architecture Decision Records (ADRs) that capture the context and rationale behind significant technical decisions."
---

# Skill: architecture-decision-records

## Purpose
Capture a meaningful architecture decision as an ADR with clear context,
options, rationale, status, and consequences. Use this workflow when the team
needs a durable record of why a significant technical direction was chosen.

## Trigger Conditions
Use this skill when:
- a significant architecture, platform, API, security, or data decision is being made
- a prior decision needs to be deprecated or superseded
- the team needs a durable decision record for onboarding or review
- the tradeoffs must be recorded before implementation proceeds

If there is no real architectural decision to capture, do not write an ADR.

## Input Boundary
The user may provide:
- the decision topic
- system context and constraints
- decision drivers
- considered options
- related or superseded ADRs
- current status or review state

Ask for missing context when the decision, drivers, or status are still ambiguous.

## Step Order (Mandatory)
1. Confirm the change deserves an ADR rather than a patch note or implementation note.
2. Capture the context, constraints, and decision drivers.
3. Record the viable options with balanced tradeoffs.
4. State the decision and why it won.
5. Record the consequences, risks, and follow-up implications.
6. Link related, deprecated, or superseded ADRs and set the status explicitly.
7. Produce a concise ADR draft ready for review.

## ADR Structure Rules
Use the smallest template that still captures the decision clearly.

The standard ADR shape usually includes:
- Title
- Status
- Context
- Decision Drivers
- Considered Options
- Decision
- Consequences
- Related Decisions
- References

For narrower cases, a lighter ADR format is acceptable as long as context,
decision, and consequences remain explicit.

Detailed templates, lifecycle guidance, and review checklists live in
[references/adr-templates.md](references/adr-templates.md).

## Evidence Expectations
- State the real constraints and decision drivers.
- Include the meaningful options, not a fake single-option ADR.
- Describe both positive and negative consequences.
- Make status and related-decision links explicit when a prior ADR is affected.
- Separate factual constraints from opinion or forecast.

## Non-Goals
- Do not use this skill for minor implementation details or routine maintenance.
- Do not turn the ADR into a general architecture essay.
- Do not hide tradeoffs or negative consequences.
- Do not rewrite accepted ADR history in place when a new ADR should supersede it.

## Output Format
1. DECISION SUMMARY

State the decision topic, status, and the main drivers.

2. CONTEXT AND OPTIONS

Describe the constraints and the meaningful alternatives considered.

3. ADR DRAFT

Provide a concise ADR in the chosen format.

4. CONSEQUENCES AND FOLLOW-UP

State the positive effects, costs, risks, and related decisions.

5. REVIEW NOTES

List anything still missing before the ADR is review-ready.

## References
- Templates and lifecycle guidance: [references/adr-templates.md](references/adr-templates.md)
