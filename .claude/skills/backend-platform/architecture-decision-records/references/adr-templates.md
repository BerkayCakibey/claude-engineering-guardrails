# ADR Templates And Lifecycle

Use these templates when `architecture-decision-records` needs more detail than
the main `SKILL.md` should carry.

## ADR Lifecycle

Typical states:

```text
Proposed -> Accepted -> Deprecated -> Superseded
             |
             -> Rejected
```

Use:
- `Proposed` while the decision is under review
- `Accepted` when the decision is made
- `Deprecated` when the decision is no longer preferred
- `Superseded` when a newer ADR replaces it
- `Rejected` when options were considered but not chosen

## Standard ADR Template

```markdown
# ADR-XXXX: <Decision title>

## Status
Accepted | Proposed | Deprecated | Superseded | Rejected

## Context
What problem exists, what constraints matter, and why a decision is needed.

## Decision Drivers
- Driver 1
- Driver 2
- Driver 3

## Considered Options
### Option A
- Pros
- Cons

### Option B
- Pros
- Cons

## Decision
State the chosen option clearly.

## Rationale
Why this option won over the others.

## Consequences
### Positive
- Benefit 1
- Benefit 2

### Negative
- Cost 1
- Cost 2

### Risks
- Risk 1 and mitigation if known

## Related Decisions
- ADR-XXXX

## References
- Internal or external supporting material
```

## Lightweight ADR Template

Use when the decision is narrow but still architectural.

```markdown
# ADR-XXXX: <Decision title>

**Status**: Accepted
**Date**: 2026-04-23

## Context
Short explanation of the problem and why this decision matters.

## Decision
State the choice.

## Consequences
**Good**: main benefits
**Bad**: main costs or risks
```

## Superseding Or Deprecation Template

Use when replacing an older decision.

```markdown
# ADR-XXXX: <New decision title>

## Status
Accepted (Supersedes ADR-YYYY)

## Context
Why the older decision no longer fits.

## Decision
State the replacement decision.

## Migration Or Transition Notes
Outline the phased transition if needed.

## Consequences
State the benefits, costs, and migration risks.
```

## Review Checklist

Before submission:
- Context clearly explains the problem
- All viable options were considered
- Tradeoffs are balanced and honest
- Consequences include costs and risks, not only benefits
- Related ADRs are linked when relevant

During review:
- Appropriate reviewers or affected teams are consulted
- Security and cost implications are covered when relevant
- Reversibility or migration impact is addressed

After acceptance:
- ADR index is updated if the repo keeps one
- Related docs or tickets are updated
- Superseded ADRs are linked explicitly
