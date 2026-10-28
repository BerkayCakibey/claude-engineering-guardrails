# Repo Security Scan Gates

Use these gates when a security review covers a repository, pull request, or
automation surface rather than a single skill directory. This is a lightweight
static review contract, not a heavyweight SAST replacement.

## Scope Gate

State exactly what is in scope before reporting findings:

- application code
- agent or skill files
- shell hooks and scripts
- package manifests and lockfiles
- CI workflows
- Docker, Terraform, Kubernetes, or cloud configuration

If the scan excludes runtime behavior, production infrastructure, private
secrets, or live dependency advisories, say that explicitly.

## Secret Gate

No secret values may appear in the review output. If a credential-like value is
found, report only the file, line, type, and a redacted fingerprint such as the
first and last two visible characters.

Check for:

- API keys, tokens, passwords, private keys, and connection strings
- committed `.env` files or examples that contain real-looking values
- logs or fixtures that include credentials
- scripts that read credential stores such as `~/.ssh`, `~/.aws`, or browser
  profile directories

## Execution Gate

Flag any path that can execute code or commands from untrusted input:

- `eval`, `exec`, dynamic imports, template execution, or deserialization
- subprocess calls with `shell=True` or string-built commands
- `curl | bash`, remote install scripts, or network-fetched code execution
- shell hooks that run on file edits, prompt submission, commits, or CI
- broad chmod, sudo, cron, systemd, PATH, profile, or shell startup edits

Treat read-only analysis differently from confirmed exploitability, but do not
hide risky primitives behind generic wording.

## Dependency Gate

Review dependency and install surfaces:

- unpinned direct dependencies in deployable or security-sensitive packages
- install-time scripts in npm, pip, uv, cargo, go, or shell bootstrap flows
- suspicious package names, typosquatting risk, or abandoned packages
- generated lockfile churn that does not match source manifest changes
- vendored binaries, archives, or large opaque files

Do not require live CVE scanning by default. If no advisory database or network
scan was used, call the dependency result a manifest review.

## Boundary Gate

Confirm that automation stays inside the expected repository or skill boundary:

- no writes outside documented output directories
- no unexpected reads from home, credential, browser, or system locations
- no symlinks escaping the reviewed directory
- no hidden remote destinations for telemetry, report upload, or update checks
- no broad glob deletes or recursive moves without a fixed safe root

## CI And Infra Gate

Check whether automation can deploy, destroy, publish, or expose resources:

- CI workflow permissions and token scopes
- deployment triggers and branch protections
- Terraform, Kubernetes, Docker, and cloud commands with destructive impact
- public buckets, unauthenticated endpoints, broad CORS, or open security groups
- secrets passed through logs, artifacts, caches, or command-line arguments

For local personal repositories, prefer local hooks and bounded validators over
remote release automation unless the repository explicitly needs releases.

## Evidence Gate

Every finding should include:

- severity: Critical, High, Medium, or Low
- file and line where possible
- the risky pattern or behavior in short redacted form
- why it matters in this repository's threat model
- the smallest practical remediation
- confidence level when the result is pattern-based

Separate confirmed issues from static-analysis leads. Do not pad the report with
generic best-practice advice when there is no concrete local evidence.

## Pass Criteria

A repository-level security scan can pass when:

- no critical or high-confidence high-severity issue remains
- all secret-like findings are redacted and triaged
- execution and boundary risks are either fixed or documented as intentional
- CI and infra surfaces have least-privilege defaults for the repository purpose
- any residual dependency risk is scoped and not presented as fully scanned
