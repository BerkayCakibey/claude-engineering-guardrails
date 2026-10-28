# SAST Triage Matrix

Use this matrix to coordinate a security review without turning every pattern
match into a finding.

## Phase 1: Map

Identify:

- entry points: routes, handlers, CLI commands, workers, webhooks
- trust boundaries: user input, files, network, database, secrets, subprocesses
- authorization model: roles, ownership checks, tenant boundaries, service tokens
- data sinks: SQL, templates, filesystem, HTTP clients, shell, serializers
- validation evidence: tests, policies, middleware, schema validators, CI checks

Output only the security-relevant map before opening specialist lanes.

## Phase 2: Route

Send each lead to the smallest matching lane:

| Lead | Specialist skill |
|---|---|
| Missing ownership or tenant checks | `sast-idor`, `sast-missingauth` |
| Business process bypass | `sast-businesslogic` |
| SQL or ORM string construction | `sast-sqli` |
| Server-side HTTP fetch or metadata access | `sast-ssrf` |
| File upload, archive, or media processing | `sast-fileupload`, `sast-pathtraversal` |
| Template rendering or user-controlled templates | `sast-ssti`, `sast-xss` |
| Shell, eval, deserialization, plugins | `sast-rce` |
| XML parsing | `sast-xxe` |
| JWT/session/token handling | `sast-jwt` |
| GraphQL schema/resolvers | `sast-graphql` |
| Prompt or instruction exposure | `prompt-leak-defense` |

Do not run every lane by default. Run only lanes supported by the map.

## Phase 3: Prove

A confirmed finding needs:

- vulnerable source and sink
- attacker-controlled input path
- missing or ineffective guard
- realistic impact
- concrete fix
- evidence from code, tests, or a reproducible scenario

A lead without this proof is a static pattern lead, not a vulnerability.

## Phase 4: Report

Group by severity:

- Critical: direct secret compromise, auth bypass, RCE, destructive cross-tenant access
- High: exploitable data access, SSRF to sensitive networks, persistent XSS, SQLi
- Medium: constrained exposure, weak guard, risky parser/default with plausible exploit
- Low: hardening, missing defense-in-depth, ambiguous pattern requiring follow-up

Never include raw secret values. Redact examples and quote only the code needed
to prove the issue.

## Exit Criteria

- specialist lanes match the mapped trust boundaries
- confirmed findings are separated from leads
- remediation is specific enough to implement
- false-positive reasons are recorded
- no external scanner is required unless the user approved it
