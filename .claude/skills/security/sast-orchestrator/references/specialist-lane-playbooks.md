# Specialist Lane Playbooks

Use these playbooks after `sast-orchestrator` has mapped entry points, trust
boundaries, sources, sinks, and existing guards.

## Shared Proof Contract

A specialist lane can report a confirmed vulnerability only when it can show:

- source: attacker-controlled input or privilege boundary
- sink: sensitive operation, data access, renderer, parser, network, shell, or token decision
- missing guard: absent, bypassable, misplaced, or incorrectly scoped control
- exploit path: realistic steps or code path
- impact: data, tenant, command, account, secret, or integrity consequence
- fix: minimal remediation at the correct layer

Anything less is a lead. Record why it is not confirmed.

## Lane Focus

| Lane | Primary proof question |
|---|---|
| `sast-idor` | Can one principal access or mutate another principal's object? |
| `sast-missingauth` | Is an endpoint or action reachable without the required identity or role? |
| `sast-businesslogic` | Can the process be reordered, replayed, skipped, or abused despite technical checks? |
| `sast-sqli` | Can untrusted input alter query structure, filtering, ordering, or raw SQL? |
| `sast-ssrf` | Can the server be made to fetch attacker-chosen internal or sensitive URLs? |
| `sast-fileupload` | Can uploaded content bypass type, size, path, malware, or execution controls? |
| `sast-pathtraversal` | Can input escape the intended filesystem root or object namespace? |
| `sast-rce` | Can input influence shell, eval, plugin execution, deserialization, or template execution? |
| `sast-xss` | Can untrusted content execute script in a user's browser context? |
| `sast-ssti` | Can input become executable template syntax? |
| `sast-xxe` | Can XML parsing read local files, hit networks, or expand unsafe entities? |
| `sast-jwt` | Can token validation, signing, expiry, issuer, audience, or key choice be bypassed? |
| `sast-graphql` | Can schema/resolver behavior bypass auth, leak fields, or cause unbounded work? |

## False-Positive Checks

- Guard exists on the actual sink path, not only on a nearby helper.
- Framework defaults are verified from code or config, not assumed.
- Sanitization is context-specific: HTML, URL, SQL, shell, path, and JSON are different contexts.
- Test-only fixtures are not production vulnerabilities unless the same path ships.
- Internal-only code still needs proof of a reachable trust boundary.

## Output Shape

```markdown
## Lane
- [specialist lane name]

## Confirmed Findings
- Severity:
- Source:
- Sink:
- Missing guard:
- Impact:
- Fix:

## Rejected Leads
- Lead:
- Rejection reason:
- Evidence:

## Evidence
- [files, lines, commands, tests, or assumptions]
```
