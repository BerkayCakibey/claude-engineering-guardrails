# Type Design Review Gates

Use these gates during code review when a change adds or reshapes domain types,
DTOs, public API schemas, SDK contracts, or typed state machines.

## What To Check

- What invariant is each important type protecting?
- Can an invalid instance be constructed from normal caller code?
- Are mutually exclusive states modeled as a union instead of optional-field
  soup?
- Are runtime schemas and static types derived from the same source where the
  repo has a schema tool?
- Are exported type changes backward compatible for callers?
- Are mutation points guarded, or can external code break invariants?

## Type Design Ratings

Use these dimensions when a type-heavy change needs a deeper review:

- Encapsulation: internal details and mutation paths are controlled.
- Invariant expression: the type shape communicates the business rule.
- Invariant usefulness: the rule prevents plausible bugs in this domain.
- Enforcement: construction, parsing, and mutation keep the type valid.

Do not require advanced type tricks for ordinary data shapes. The goal is to
make invalid states harder to represent without making maintenance harder.
