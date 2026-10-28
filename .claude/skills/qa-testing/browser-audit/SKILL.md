---
name: browser-audit
description: Capture screenshots, walk same-origin pages, and audit browser-visible issues such as console errors, failed requests, horizontal overflow, oversized elements, broken images, and obstructive overlays. Use when Claude needs to inspect a website in desktop/mobile/tablet viewports, compare responsive behavior, collect browser artifacts, or produce deterministic visual QA evidence.
argument-hint: "[target URL] [mode: capture|walk|audit] [viewport: mobile|tablet|desktop|all]"
disable-model-invocation: false
---

# Browser Audit

## Overview

Use this skill to run a deterministic Playwright-based browser audit against a public or local website. The skill separates orchestration guidance from browser automation: `SKILL.md` defines when and how to use the audit, while `scripts/run_browser_audit.js` performs the actual crawl, screenshot capture, logging, and finding generation.

## Workflow

1. Confirm the target URL and mode.
2. Choose viewport scope.
3. Run the browser runner.
4. Inspect generated artifacts.
5. Report findings with file-backed evidence.

## Modes

- `capture`
  Capture screenshots for one page without crawling.
- `walk`
  Visit a bounded set of same-origin pages, capture screenshots, and record page metadata.
- `audit`
  Run `walk` behavior plus console, network, and layout checks.

## Inputs

Call the runner with:

- `--url <target>`
- `--mode capture|walk|audit`
- `--viewport mobile|tablet|desktop|all`
- `--out-dir <artifact-dir>`
- `--screenshots-dir <image-dir>`
- `--screenshot-mode fullpage|viewport`
- `--scroll-prime auto|off`
- `--interaction-profile common|off`
- `--cache-mode default|no-cache|bust`
- `--max-pages <n>`
- `--max-depth <n>`
- `--include-path <csv>`
- `--exclude-path <csv>`
- `--wait-until load|domcontentloaded|networkidle`
- `--timeout <ms>`
- `--format json|md|html|both`

The runner also supports:

- `--help`
  Print CLI usage, defaults, and examples.

Defaults are tuned for practical review:

- mode: `audit`
- viewport: `desktop`
- screenshot-mode: `fullpage`
- scroll-prime: `auto`
- interaction-profile: `common`
- cache-mode: `default`
- max-pages: `10`
- max-depth: `10`

This means the runner prefers browser-sized review by default, crawls same-origin pages until the site is exhausted or `10` pages are reached, and only captures mobile or tablet when explicitly requested.

## Walk Rules

Apply these deterministic rules:

1. Stay on the same origin.
2. Visit each normalized URL once.
3. Prioritize links in this order:
   `header/nav` -> `main` -> `aside` -> `footer`
4. Ignore:
   - hash-only links
   - `mailto:` and `tel:`
   - obvious login/logout/account paths
   - downloads
   - query-heavy URLs that expand crawl state
5. Stop when `max-pages` or `max-depth` is reached.

Path filters:

- Use `--include-path` with a comma-separated list to keep the crawl inside specific same-origin path fragments.
- Use `--exclude-path` with a comma-separated list to skip specific same-origin path fragments.
- Exclude rules win over include rules.

Read [references/failure-taxonomy.md](references/failure-taxonomy.md) for the exact finding categories and thresholds.

## Artifacts

The runner emits:

- WSL artifact directory:
  - `run.json`
  - `report.json`
  - `summary.md` when `--format md|both`
  - `report.html` when `--format html|both`
  - `logs/console.jsonl`
  - `logs/network.jsonl`
- Windows screenshots directory:
  - `<viewport>/<index>_<slug>_<viewport>.png`
  - optional state captures:
    - `<viewport>/<index>_<slug>_<viewport>_journey.png`
    - `<viewport>/<index>_<slug>_<viewport>_menu-open.png`
    - `<viewport>/<index>_<slug>_<viewport>_disclosure-open.png`

Screenshots are full-page by default, so long pages include content below the fold. Use `--screenshot-mode viewport` only when the visible viewport itself is the thing being inspected.
The runner also primes pages by scrolling through them before the main capture, which helps lazy-loaded sections render. With the default `--interaction-profile common`, it additionally takes extra viewport screenshots for common in-journey states such as scrolled content, open menus, and expanded disclosures when those states can be triggered safely.
Use `--cache-mode no-cache` to send no-cache headers or `--cache-mode bust` to append a cache-busting query parameter when CDN or browser cache is suspected.

Read [references/report-schema.md](references/report-schema.md) for the required JSON fields.
Use [references/qa-presets.md](references/qa-presets.md) to choose quick, standard, or exhaustive browser evidence without adding another browser stack.
Use [references/e2e-journey-gates.md](references/e2e-journey-gates.md) when a browser-visible change needs durable E2E journey evidence rather than a one-off audit artifact.

## Output Interpretation

- Use `run.json` for run metadata and exit status.
- Use `report.json` for machine-readable findings.
- Use `summary.md` for human-readable review.
- Use `report.html` when you want a single shareable file with linked screenshots.
- Use the `screenshots/` tree as evidence when reporting responsive issues.
- Use `noise_events` for known third-party telemetry noise that was observed but excluded from actionable findings.

When the user asks for "browser-like" inspection, prefer `audit` with `--viewport all`.
When the user wants the whole rendered page, keep the default `--screenshot-mode fullpage`.
When the user wants "what I see while navigating", keep `--scroll-prime auto` and `--interaction-profile common`.
When the user wants mobile behavior with the same journey-style capture, use `--viewport mobile` or `--viewport all`.

For owned-domain smoke audits, use [references/owned-domain-workflow.md](references/owned-domain-workflow.md). It defines the bounded all-viewport preset for `akay.example.com` and `juice.example.com`, keeps artifacts under `/tmp`, and documents how to interpret common Cloudflare telemetry noise.

## Examples

Desktop full-site audit with defaults:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com
```

Mobile journey capture:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com --viewport mobile
```

Desktop, tablet, and mobile together:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com --viewport all
```

Visible viewport only:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com --screenshot-mode viewport
```

Show CLI help:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --help
```

Run the lightweight runner self-test without launching a browser:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --self-test
```

Restrict crawl to selected paths:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com --include-path /blog,/docs --exclude-path /docs/private
```

Bypass cache aggressively:

```bash
node $HOME/.claude/skills/browser-audit/scripts/run_browser_audit.js --url https://example.com --cache-mode bust
```

## Installation

Use Node 20+ when possible. Node 18 can work for basic usage but is not the preferred target.

If `--out-dir` is omitted, non-image artifacts go under:

```text
$HOME/.claude/skills/browser-audit/artifacts/<target-slug>-<timestamp>
```

If `--screenshots-dir` is omitted, screenshots go under:

```text
$HOME/.claude/skills/browser-audit/artifacts/<target-slug>-<timestamp>/screenshots
```

Use `--screenshots-dir` when you want screenshots in a separate Windows-visible or project-specific location.

From the skill directory:

```bash
cd $HOME/.claude/skills/browser-audit && npm install && npx playwright install
```

If the environment is missing browser dependencies, use:

```bash
npx playwright install --with-deps
```

## Resources

- Runner: [scripts/run_browser_audit.js](scripts/run_browser_audit.js)
- Viewports: [references/viewports.json](references/viewports.json)
- Findings: [references/failure-taxonomy.md](references/failure-taxonomy.md)
- Report contract: [references/report-schema.md](references/report-schema.md)
- QA presets: [references/qa-presets.md](references/qa-presets.md)
- Owned domain workflow: [references/owned-domain-workflow.md](references/owned-domain-workflow.md)
- E2E journey gates: [references/e2e-journey-gates.md](references/e2e-journey-gates.md)
- Summary format: [templates/summary.md](templates/summary.md)
