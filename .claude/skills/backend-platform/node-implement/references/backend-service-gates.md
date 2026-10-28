# Backend Service Gates

Use these gates when a Node, TypeScript, or JavaScript change touches API
routes, service layers, database access, queues, or server-side integrations.

## Boundary Gate

Keep responsibilities separated:

- route/controller: HTTP parsing, auth context, response shaping
- service/use case: business decision and orchestration
- repository/client: persistence or external API access
- schema/model: input validation and normalized data shape

Do not introduce a repository/service split for tiny CRUD code unless the
surrounding repo already uses it or the change adds real business rules.

## Validation And Error Gate

- Validate external input at the boundary with the repo's existing schema tool.
- Return consistent error payloads and status codes.
- Preserve request IDs or trace IDs when the repo already uses them.
- Log unexpected errors without exposing secrets, tokens, or raw payloads.
- Keep domain errors distinct from transport/framework errors.

## Data Access Gate

- Select only needed columns or fields.
- Avoid N+1 loops by batching or joining.
- Paginate or cap list/search responses.
- Use explicit transactions for multi-write consistency.
- Add timeouts for external calls when the client supports them.

## Cache And Job Gate

- Give cache keys a clear namespace and TTL.
- Define invalidation for writes that affect cached reads.
- Make queued/background jobs idempotent where retries are possible.
- Record retry limits and dead-letter behavior for durable queues.
- Keep in-memory queues only for local or non-critical workflows.

## Verification Gate

Use repo-native checks first:

- route/unit tests for validation and error paths
- integration tests for repository/client boundaries when available
- type-check and lint for contract drift
- one negative test for auth, permission, or invalid input when behavior changes
