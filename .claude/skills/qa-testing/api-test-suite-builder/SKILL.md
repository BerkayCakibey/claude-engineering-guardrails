---
name: "api-test-suite-builder"
description: "Generates comprehensive API test suites covering endpoints, auth, validation, and error scenarios"
---

# Skill: api-test-suite-builder

## Purpose
Design and draft a bounded API test suite for an existing route surface. Use
this workflow to map endpoints, choose the minimum defensible test matrix, and
produce repo-native test scaffolds without guessing the contract.

## Trigger Conditions
Use this skill when:
- a new API surface needs a first-pass test scaffold
- an existing API has weak or missing regression coverage
- you need to compare current tests against the actual route map
- an API review or security review needs adversarial request coverage
- a change touches auth, validation, pagination, file upload, or rate-limit behavior

If the API surface or target framework is unclear, inspect the repo first
before proposing tests.

## Step Order (Mandatory)
1. Detect the API framework and where route definitions actually live.
2. Build a route inventory with methods, paths, auth boundaries, and body/query inputs.
3. Read each handler or controller before drafting tests.
4. Choose the smallest useful coverage matrix for each route group.
5. Draft repo-native test files or test case outlines using the existing runner
   and fixture style.
6. State what the draft covers, what it does not cover yet, and how it should
   be executed.

## Framework Detection
Use repo-native discovery commands that match the stack:

### Next.js App Router
```bash
find ./app/api -name "route.ts" -o -name "route.js" | sort
```

### Express
```bash
rg -n "router\\.(get|post|put|delete|patch)|app\\.(get|post|put|delete|patch)" src/
```

### FastAPI
```bash
rg -n "@(app|router)\\.(get|post|put|delete|patch)" --glob "*.py"
```

### Django REST Framework
```bash
rg -n "router\\.register|path\\(|re_path\\(|url\\(" --glob "*.py"
```

Do not stop at route discovery. Read the actual handlers to confirm:
- auth and role requirements
- request body or query schema
- status code contract
- ownership or business-rule checks
- response shape and sensitive-field rules

## Coverage Matrix
For authenticated routes, cover the minimum auth boundary:
- missing auth header
- malformed or invalid token
- expired token when the system distinguishes expiry
- wrong role or wrong owner
- valid authorized request

For mutating routes with request bodies, cover the minimum validation boundary:
- empty body or missing required fields
- wrong type or malformed payload
- lower and upper boundary values when limits exist
- hostile strings or injection attempts for string inputs
- null handling where schema or framework behavior is strict

Also include when relevant:
- pagination bounds and empty pages
- file upload MIME, size, and empty-file cases
- rate-limit boundaries
- sensitive-field omission in responses

## Test Structure Rules
- Group tests by endpoint or closely related route family.
- Name tests by behavior, not by matrix row number.
- Use factories or fixtures instead of hardcoded IDs.
- Assert response shape and key fields, not only status codes.
- Keep shared setup minimal and clean up state explicitly.

Detailed examples live in [references/example-test-files.md](references/example-test-files.md).

## Evidence Expectations
- Cite the route files or handlers used to derive the scaffold.
- Make the expected status codes and contract assumptions explicit.
- State the runner and libraries the generated suite expects, such as
  Vitest + Supertest or Pytest + httpx.
- Call out any contract uncertainty instead of fabricating expected behavior.

## Non-Goals
- Do not invent a new test runner or fixture stack when the repo already has one.
- Do not generate a giant suite before confirming the real route contract.
- Do not hardcode IDs, secrets, or environment-specific values into examples.
- Do not treat the scaffold as complete proof until the target repo actually runs it.

## Output Format
1. API SURFACE

List the route groups, methods, and framework surface being targeted.

2. CONTRACT ASSUMPTIONS

State the auth, input, and response assumptions taken from the handler code.

3. TEST MATRIX

List the must-cover auth, validation, error, and boundary cases.

4. TEST FILE PLAN

Name the proposed test files or suites and what each one covers.

5. GENERATED TEST DRAFT

Provide repo-native test code or scaffolding that matches the target stack.

6. EXECUTION NOTES

State how the draft should be wired into the repo's runner and what remains to
be validated.

## References
- Example test scaffolds: [references/example-test-files.md](references/example-test-files.md)
