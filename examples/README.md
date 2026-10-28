# Examples

This directory contains **small demonstration projects** used to show how the component library's workflows operate in practice.

The examples are intentionally simple and sometimes imperfect.
Their purpose is to allow engineers to quickly experiment with the library's skills and agents without using a real production repository.

---

## Directory Structure

```
examples
│
├── terraform/
│   └── main.tf              # AWS S3 bucket (CloudOps demo)
│
├── python/
│   └── broken_script.py     # Intentionally flawed script (bug fixing demo)
│
├── go/
│   ├── main.go              # User microservice (Go demo)
│   └── README.md
│
└── nodejs/
    ├── server.js            # User microservice (Node.js demo)
    └── README.md
```

---

## Terraform Example

A minimal Terraform configuration that creates a single AWS S3 bucket.

**Relevant components:**
- `terraform-change-planner` skill
- `terraform-safety-reviewer` agent

**Workflow:**
```
1. Inspect Terraform code
2. Run terraform-change-planner
3. Generate a change plan
4. Analyze risk with terraform-safety-reviewer
5. Prepare pull request description
```

---

## Python Example

Small Python script with reviewable structure, environment handling, and
explicit file-processing behavior.

Use it to exercise code-review, debugging, security-review, and
quality-analysis components against a simple script that still leaves room for
practical feedback.

**Relevant skills:**
- `python-quality-review`
- `python-security-review`
- `test-strategy-planner`
- `bugfix-root-cause-analyzer`

**Workflow:**
```
1. Inspect the script
2. Run python-quality-review
3. Identify code issues
4. Run python-security-review
5. Propose fixes
6. Generate testing strategy
```

---

## Go Example

Minimal user management HTTP service demonstrating:
- RESTful endpoint patterns
- JSON request/response handling
- Handler pattern

**Relevant skills:**
- `golang-pro`

**Run:**
```bash
cd examples/go && go run main.go
```

---

## Node.js Example

Minimal user management HTTP service demonstrating:
- Core Node.js http module
- URL routing pattern
- Promise-based async handlers

**Relevant skills:**
- `node-implement`

**Run:**
```bash
cd examples/nodejs && node server.js
```

---

## Using the Examples

Clone the repository, inspect the relevant skills, then copy the components you want into your own setup. Use the installed workflows against these examples from your target Claude session, not from the component-library checkout itself.

```bash
git clone <repo-url>
cd <repo-dir>

# Copy only the components you want into your own Claude setup
mkdir -p ~/.claude/skills ~/.claude/agents
cp -R .claude/skills/backend-platform/golang-pro ~/.claude/skills/golang-pro
cp -R .claude/skills/backend-platform/node-implement ~/.claude/skills/node-implement
cp .claude/agents/engineering/developer.md ~/.claude/agents/developer.md

# Then move to the project or playground where you actually run Claude
cd ~/projects/your-app
claude
```

If you explicitly want archived maintainer tooling, treat it as separate
maintainer-only material instead of assuming it is part of the default example
flow.

Example prompts:

```
Analyze the Go service using golang-pro.

Review the Python script using python-quality-review.

Use terraform-change-planner on the Terraform example.
```

These examples provide a **safe playground for exploring installed component-library capabilities**.
