# MCP Validation Checklist

## Structural Integrity
- [ ] Tool names are unique across the manifest
- [ ] Tool names use lowercase snake_case (3-64 chars, `[a-z0-9_]`)
- [ ] `inputSchema.type` is always `"object"`
- [ ] Every `required` field exists in `properties`
- [ ] No empty `properties` objects (warn if inputs truly optional)
- [ ] Tools, resources, and prompts are separated by purpose

## Descriptive Quality
- [ ] All tools include actionable descriptions (≥10 chars)
- [ ] Descriptions start with a verb ("Create…", "Retrieve…", "Delete…")
- [ ] Parameter descriptions explain expected values, not just types

## Security & Safety
- [ ] Auth tokens and secrets are NOT exposed in tool schemas
- [ ] Destructive tools require explicit confirmation input parameters
- [ ] No tool accepts arbitrary URLs or file paths without validation
- [ ] Outbound host allowlists are explicit where applicable
- [ ] Local HTTP servers bind to `127.0.0.1` unless remote exposure is intentional
- [ ] stdio servers do not write logs to stdout

## Versioning & Compatibility
- [ ] Breaking tool changes use new tool IDs (never rename in-place)
- [ ] Additive-only changes for non-breaking updates
- [ ] Contract migration notes exist when versioned releases need them
- [ ] Deprecated tools include sunset timeline in description

## Runtime & Error Handling
- [ ] Error responses use consistent structure (`code`, `message`, `details`)
- [ ] Timeout and rate-limit behaviors are documented
- [ ] Large response payloads are paginated or truncated
- [ ] FastMCP servers pass `inspect`, `list --json`, and at least one real call per new tool
