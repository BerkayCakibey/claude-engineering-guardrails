---
description: Run a security audit on the codebase -- OWASP, auth, secrets, IaC
argument-hint: "[scope or focus area]"
---

# Security Review

Entry point for security audits.

## Step 1: Explore the codebase

Use the Skill tool to invoke repo-navigator:
- skill: repo-navigator
- Prompt: explore the codebase structure for security review of `$ARGUMENTS`

## Step 2: Run security audit

Use the Skill tool to invoke sast-orchestrator when `$ARGUMENTS` asks for
multi-language SAST, vulnerability classes, endpoint review, auth review, or a
component-library security pass:
- skill: sast-orchestrator
- Reference: `references/sast-triage-matrix.md`
- Goal: map trust boundaries, route only relevant specialist lanes, and separate confirmed findings from static pattern leads

Use the Skill tool to invoke skill-security-auditor when `$ARGUMENTS` includes
skills, hooks, generated scripts, local plugins, or repository automation:
- skill: skill-security-auditor
- Reference: `references/repo-security-scan-gates.md`
- Goal: apply scope, secret, execution, dependency, boundary, CI/infra, and
  evidence gates without adding heavyweight scanners by default

Use the Agent tool to spawn the security agent:
- agent: security
- Task: perform a full security audit on the codebase, focusing on `$ARGUMENTS`

The security agent will:
- Check for OWASP Top 10 vulnerabilities
- Review authentication and authorization flows
- Scan for hardcoded secrets and credential exposure
- Review API endpoints for access control
- Check IaC security (Terraform, Docker, K8s manifests)
- Assess dependency vulnerabilities

## Step 3: Report

Review the security agent's findings and present:
- Critical and high severity issues first
- Concrete remediation steps for each finding
- Summary of the overall security posture

## Step 4: Self-check the report

Use the Skill tool to invoke self-check:
- skill: self-check
- Verify severity ordering, secret redaction, evidence quality, remediation specificity, and scope alignment
- Confirm SAST outputs distinguish confirmed vulnerabilities from static pattern leads

## Rules

- This is a read-only audit -- do not modify code
- Never output actual secret values if found
- Separate confirmed issues from static pattern leads
- Route specialist SAST lanes from the trust-boundary map; do not run every lane blindly
- Classify all findings by severity (Critical/High/Medium/Low)
