---
name: clean-ddd-hexagonal
description: Proactively apply when designing APIs, microservices, or scalable backend structure. Triggers on DDD, Clean Architecture, Hexagonal, ports and adapters, entities, value objects, domain events, CQRS, event sourcing, repository pattern, use cases, onion architecture, outbox pattern, aggregate root, anti-corruption layer. Use when working with domain models, aggregates, repositories, or bounded contexts. Clean Architecture + DDD + Hexagonal patterns for backend services, language-agnostic (Go, Rust, Python, TypeScript, Java, C#).
argument-hint: "[architecture question or design task]"
---

# Clean Architecture + DDD + Hexagonal

## Purpose
Design or review service boundaries using DDD, Clean Architecture, and Hexagonal patterns only when the domain and change scope justify that added structure.

## Trigger Conditions
- The user is designing a service, bounded context, domain model, or backend module with meaningful business rules.
- The work needs explicit boundaries between domain logic, application orchestration, and infrastructure adapters.
- The request mentions entities, value objects, aggregates, repositories, ports and adapters, CQRS, domain events, or dependency-direction rules.
- Multiple entry points or replaceable integrations make boundary discipline more important than a simple CRUD layout.

## Input Boundary
- Capture the domain language, core use cases, external systems, transaction boundaries, and team constraints first.
- Confirm whether the system is a long-lived service or a short-lived utility. Do not default to DDD or CQRS for small CRUD flows.
- Inspect the current repository structure before proposing new layers, ports, or aggregates.
- Treat the reference documents in `references/` as the detailed source of patterns. Keep the runtime response focused on the decision at hand.

## Step Order
1. Confirm whether the problem is simple CRUD, moderate workflow orchestration, or a genuinely rich domain.
2. Identify the stable domain concepts, consistency boundaries, and side-effecting integrations.
3. Place responsibilities by boundary:
   - domain: pure business rules, entities, value objects, aggregates, domain events
   - application: use cases, orchestration, transactions, policy coordination
   - infrastructure: persistence, messaging, HTTP, framework glue, external systems
4. Define only the ports and adapters the current change needs. Do not multiply abstractions ahead of evidence.
5. Validate the dependency rule: infrastructure depends inward, and domain stays free of framework or transport concerns.
6. Call out the smallest viable architecture that satisfies the problem, including where the user should stay simpler than the full pattern set.

## Decision Gates
- Use DDD tactical patterns when business invariants, language precision, and aggregate boundaries materially affect correctness.
- Use Hexagonal boundaries when multiple delivery channels or replaceable integrations make ports and adapters useful.
- Use CQRS or domain events only when read/write pressures, consistency boundaries, or integration workflows justify the complexity.
- Reject architecture proposals that create layers without a concrete change in testing, consistency, or integration flexibility.

## Evidence Expectations
- Name the candidate aggregates, use cases, ports, and adapters explicitly rather than speaking in generic architecture slogans.
- Explain why each layer exists in the current problem, not why the pattern is generally popular.
- Call out concrete risks such as anemic domain models, controllers bypassing application services, or cross-aggregate transactions.
- If you recommend staying simpler, state that directly and explain which heavier patterns are unnecessary.

## Reference Index
- `references/CHEATSHEET.md`: quick boundary and placement guide
- `references/LAYERS.md`: detailed layer responsibilities
- `references/DDD-STRATEGIC.md`: bounded contexts and context mapping
- `references/DDD-TACTICAL.md`: entities, value objects, aggregates, repositories
- `references/HEXAGONAL.md`: ports, adapters, naming, dependency direction
- `references/CQRS-EVENTS.md`: command/query separation and event-driven boundaries
- `references/TESTING.md`: architecture, unit, and integration testing guidance

## Non-Goals
- Do not prescribe Clean Architecture, DDD, or Hexagonal structure for simple scripts, prototypes, or straight CRUD without evidence.
- Do not generate large boilerplate directory trees just to match pattern names.
- Do not introduce CQRS, event sourcing, or extra ports when a direct workflow is sufficient.
- Do not treat the references as material to paste wholesale into the answer; use them to support the decision.

## Output Format
```markdown
## Architecture Fit
- [why DDD/Clean/Hexagonal is or is not justified here]

## Proposed Boundaries
- Domain: [entities, value objects, aggregates, rules]
- Application: [use cases, orchestration, transaction handling]
- Infrastructure: [adapters, persistence, messaging, HTTP]

## Key Decisions
- [port and adapter choices]
- [consistency boundaries]
- [patterns to include or avoid]

## Risks To Watch
- [specific boundary or complexity risks]

## Next Step
- [smallest concrete implementation or review step]
```
