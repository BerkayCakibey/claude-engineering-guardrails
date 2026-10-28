---
name: golang-pro
description: Use when building Go applications requiring concurrent programming, microservices architecture, or high-performance systems. Invoke for goroutines, channels, Go generics, gRPC integration.
---

# Skill: golang-pro

## Purpose
Implement or refine Go code using idiomatic package structure, interfaces,
concurrency, generics, testing, and performance discipline. Use this workflow
when the task is specifically about Go code rather than language-agnostic
routing or planning.

## Trigger Conditions
Use this skill when:
- building or fixing concurrent Go applications with goroutines or channels
- implementing Go APIs, microservices, CLIs, or system utilities
- designing or tightening interfaces and Go package boundaries
- adding table-driven tests, benchmarks, or race-safe behavior
- working with Go generics, gRPC, or performance-sensitive paths

Use `repo-navigator` first when the repository structure is still unclear.

## Step Order (Mandatory)
1. Inspect the existing Go module layout, package boundaries, and local patterns.
2. Choose the smallest interface and package changes needed for the task.
3. Implement with explicit error handling, context propagation, and clear lifecycle management.
4. Add or adjust tests and benchmarks when behavior or performance claims changed.
5. Run the repo-native Go validation commands and call out any concurrency or performance caveats.

## Reference Loading
Load the specific reference that matches the task instead of pulling everything in:
- `references/concurrency.md` for goroutines, channels, `select`, and sync primitives
- `references/interfaces.md` for interface design and composition
- `references/generics.md` for type parameters and constraints
- `references/testing.md` for table-driven tests, benchmarks, and fuzzing
- `references/project-structure.md` for module layout, `go.mod`, and internal packages

## Hard Rules
- Use `gofmt` and the repo's Go lint path when available.
- Add `context.Context` to blocking or request-scoped operations.
- Handle errors explicitly and wrap propagated errors with context.
- Prefer small interfaces and composition over broad abstraction layers.
- Write table-driven tests with subtests when behavior changes.
- Run the race detector when concurrency behavior is part of the task.

Do not:
- ignore errors without justification
- use `panic` for normal error handling
- create goroutines without clear lifecycle or cancellation handling
- reach for reflection without a real need
- introduce generics where simple concrete types are clearer

## Evidence Expectations
- State the package or module boundary you followed.
- State the interface, concurrency, or generics decision you made.
- State the validation commands that prove the change, such as `go test`,
  `go test -race`, or targeted benchmarks when relevant.
- Call out performance or lifecycle risk if the task changes concurrency behavior.

## Non-Goals
- Do not invent a microservice architecture when the repo is not already structured that way.
- Do not treat every Go task as a performance-optimization exercise.
- Do not bypass repo-native patterns for package structure, configuration, or testing.

## Output Format
1. GO TASK BOUNDARY

State the package, module, or subsystem being changed.

2. DESIGN DECISIONS

State the interface, package, concurrency, or generics choices that matter.

3. IMPLEMENTATION SHAPE

Describe the files, types, and functions that need to change.

4. TEST AND VALIDATION

State the tests, race checks, or benchmarks required to prove the change.

## References
- Concurrency: [references/concurrency.md](references/concurrency.md)
- Interfaces: [references/interfaces.md](references/interfaces.md)
- Generics: [references/generics.md](references/generics.md)
- Testing: [references/testing.md](references/testing.md)
- Project structure: [references/project-structure.md](references/project-structure.md)
