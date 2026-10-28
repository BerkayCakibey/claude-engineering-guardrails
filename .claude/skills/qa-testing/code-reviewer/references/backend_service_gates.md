# Backend Service Review Gates

Use these checks during code review when a change touches API routes, backend
services, persistence, queues, caching, or server-side integrations.

## Architecture Boundaries

- Routes/controllers should not contain business workflows beyond request
  parsing, auth context extraction, and response shaping.
- Service/use-case code should not directly depend on HTTP response objects.
- Repositories or clients should own persistence and external API details.
- Do not require DDD, CQRS, or hexagonal architecture for simple CRUD changes;
  use the existing repo boundary unless the change introduces real complexity.

## API And Validation

- Validate untrusted input before it reaches business logic.
- Keep error response shapes consistent with the rest of the service.
- Do not leak stack traces, secrets, auth headers, or raw sensitive payloads.
- Review authn and authz separately: a valid identity is not enough for access.
- Check pagination, filtering, and sorting behavior for list endpoints.

## Data And Performance

- Watch for `select *`, unbounded reads, missing limits, and N+1 loops.
- Confirm transaction boundaries for multi-write operations.
- Require timeouts and explicit retry limits for external calls.
- Check cache TTL, invalidation path, and key scoping.
- For background jobs, check idempotency, retry, and failure visibility.

## Review Evidence

Findings should point to the file and behavior, then give the smallest fix. Do
not ask for broad architecture rewrites when a local boundary, validation, or
query fix is enough.
