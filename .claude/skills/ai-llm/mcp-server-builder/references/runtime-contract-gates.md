# MCP Runtime Contract Gates

Use these gates before integrating an MCP server with a real client. They merge
the useful external MCP pattern guidance into claude-engineering-guardrails's existing
OpenAPI-to-MCP and MCP builder workflows without adding another active skill.

## Surface Gate

Pick the smallest useful MCP surface before writing handlers:

- tools for actions and computed results
- resources for stable read-only data, schemas, reports, or policy documents
- prompts for reusable LLM instructions that a client should explicitly surface

Do not convert every API endpoint or document into a prompt. Start with the
highest-value read/list/search operations, then add mutating tools only when the
confirmation and auth model are clear.

## Tool Contract Gate

Every tool contract must be understandable without reading the implementation:

- concrete verb-first name with service context
- explicit typed parameters with size/range constraints
- structured JSON-safe result where possible
- pagination or truncation for list/search responses
- read-only, destructive, idempotent, and open-world annotations
- confirmation input for destructive or costly operations

Reject vague tools such as `run`, `process`, `execute`, or `do_thing` unless the
server is intentionally a constrained command runner with a separate allowlist.

## Transport Gate

Choose transport from deployment shape:

- stdio for local single-user desktop or CLI integrations
- Streamable HTTP for remote or multi-client service integrations
- legacy SSE only for backward compatibility with a known client

For local HTTP servers, bind to `127.0.0.1` by default, validate origins when the
framework supports it, and avoid logging MCP protocol traffic to stdout when
using stdio.

## FastMCP Smoke Gate

For Python/FastMCP servers, do not stop at import success:

- `fastmcp inspect <file.py:mcp>` succeeds
- `fastmcp list <server spec> --json` succeeds
- at least one real `fastmcp call` succeeds for every new tool
- optional environment variables are documented before client installation
- the server imports without network calls or destructive side effects

If FastMCP is not installed in the environment, record that limitation instead
of claiming runtime validation passed.

## Client Install Gate

Install into Claude Code, Claude Desktop, Cursor, or another MCP client only
after local contract checks pass. Before installing:

- confirm the exact command, working directory, and environment variables
- keep credentials in the client config or environment, not in schemas or logs
- verify the server name will not collide with an existing configured server
- keep generated files and custom edits separated enough to review diffs

## Compatibility Gate

Treat tool names and schema keys as public contracts once a client uses them:

- add fields instead of changing existing meanings
- create a new tool name for breaking behavior changes
- mark old tools as deprecated in the description before removing them
- keep a short contract migration note when versioned releases exist
- snapshot the generated `tool_manifest.json` or equivalent contract output

This repository does not maintain a project changelog by default; MCP contract
notes should stay local to the server package only when they are actually needed.
