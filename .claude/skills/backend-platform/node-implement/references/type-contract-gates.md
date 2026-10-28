# Type Contract Gates

Use these gates when TypeScript changes add or reshape domain types, DTOs,
schema-derived types, API clients, SDK contracts, or state machines.

## Invariant Gate

- State the invariant each important type is meant to protect.
- Prefer compile-time guarantees over comments.
- Use discriminated unions for mutually exclusive states.
- Use literal unions or enums for closed sets.
- Keep impossible combinations out of the type shape.
- Validate at construction or boundary when the type system cannot enforce it.

## Boundary Gate

- Treat external input as unknown until parsed.
- Keep runtime schemas and inferred static types aligned.
- Do not let API response types drift from OpenAPI, GraphQL, SDK, or database
  contract sources.
- Preserve backward compatibility for exported types used by callers.

## Encapsulation Gate

- Keep mutation points small and guarded.
- Avoid exposing mutable arrays, maps, or nested objects that can break
  invariants from outside the module.
- Prefer factories or constructors when creating a valid instance requires
  checks or normalization.
- Do not add clever type machinery when a simpler explicit shape communicates
  the contract better.

## Review Smells

- `any` where a narrower unknown, generic, or domain type is possible
- optional fields used to model distinct states instead of a union
- boolean flag clusters where a status union would be clearer
- duplicated DTO/domain/API types that can silently drift
- validation logic repeated differently across call sites
- type assertions hiding real uncertainty
