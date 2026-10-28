---
name: "api-design-reviewer"
description: "Review API design for contract clarity, compatibility, boundary discipline, and operational quality."
---

# API Design Reviewer

## Purpose
Review API surfaces with a bar higher than "looks REST-ish." This skill is for contract quality, not only naming style.

## Use When
- A repo exposes HTTP or RPC endpoints and the user wants review feedback.
- An OpenAPI or schema diff may contain breaking changes.
- A new endpoint, version, or pagination/error model needs design review before implementation hardens.

## Review Workflow
1. Map the API surface under review: endpoints, schemas, auth, pagination, error model, and clients.
2. Decide whether this is:
   - first-pass design review
   - breaking change review
   - quality regression review on an existing spec
3. Prefer concrete artifacts:
   - OpenAPI specs
   - handlers and DTOs
   - generated types or SDKs
   - changelog or version diff
4. Run the bundled scripts when they fit the evidence:
   - `scripts/api_linter.py`
   - `scripts/breaking_change_detector.py`
   - `scripts/api_scorecard.py`
5. Separate confirmed contract issues from design preference.

## Review Gates
### Contract And Compatibility
- breaking changes are called out explicitly
- versioning strategy matches the scale of the change
- nullable, optional, enum, and discriminator choices reflect real domain states
- generated types or SDKs stay aligned with the contract

### Boundary Quality
- handlers own transport concerns, not deep business logic
- persistence and external API calls stay behind clear boundaries
- list endpoints define pagination or explicit caps
- multi-write flows define transaction or compensation behavior

### API Usability
- resource naming is consistent and predictable
- response and error shapes are stable across endpoints
- idempotency and retry expectations are explicit where needed
- auth and rate-limit behavior are not implicit or hand-waved

### Operational Quality
- documentation and examples are sufficient for callers
- observability and request correlation are considered
- migration or rollout notes exist for disruptive changes

## References
- `references/rest_design_rules.md`
- `references/api_antipatterns.md`

Use those references for deeper rules and examples. Keep the main review anchored to the repo's actual contract rather than repeating generic API handbook content.

## Output Requirements
```markdown
## Scope
- [surface reviewed, artifacts used]

## Findings
- Severity: HIGH | MEDIUM | LOW
- Location: path:line or endpoint/schema
- Issue: [concrete contract or design problem]
- Fix direction: [smallest useful correction]

## Compatibility Notes
- [breaking changes, migration needs, or versioning call]

## Evidence
- [specs, diffs, scripts, files, reasoning basis]
```
