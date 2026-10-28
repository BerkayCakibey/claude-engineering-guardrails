# Reviewer Verification Matrix

Use this matrix for read-only language reviewer agents. A reviewer should not
invent commands; it should discover repo-native commands first, then recommend
the smallest verification set that proves or disproves its findings.

## Shared Rules

- Prefer package scripts, Make targets, task runners, CI config, and existing docs.
- Separate commands that were run from commands that are only recommended.
- Keep findings tied to file and line evidence.
- Flag false-green risk when tests assert implementation details, mocks, snapshots,
  or no-op success paths instead of user-visible behavior.
- Do not push, deploy, create templates, or add release/changelog surfaces.

## Language Defaults

| Surface | Typical checks when repo-native commands exist |
|---|---|
| TypeScript | `npm test`, `npm run lint`, `npm run typecheck`, `npm run build`, focused framework tests |
| Python | `pytest`, `ruff check`, `mypy` or `basedpyright`, package/build smoke, import smoke |
| Go | `go test ./...`, `go vet ./...`, race tests for concurrency-sensitive code, benchmark when performance is claimed |
| Rust | `cargo test`, `cargo clippy --all-targets`, `cargo fmt --check`, `cargo check`, feature-matrix checks when relevant |
| Java | `mvn test`, `mvn verify`, `gradle test`, `gradle check`, focused module tests |
| Kotlin | `gradle test`, `gradle check`, `gradle lint`, `mvn test`, Android/KMP targets when relevant |
| C++ | `cmake --build`, `ctest`, `make test`, `ninja test`, clang-tidy, sanitizer runs |
| .NET | `dotnet test`, `dotnet build`, `dotnet format --verify-no-changes`, analyzer targets |

## Finding Quality Bar

A finding is actionable when it includes:

- location
- failure mode
- why the current code permits it
- minimal fix direction
- verification command or missing-test recommendation

If the reviewer cannot identify a command, it must say so and recommend the
smallest command to add or document.
