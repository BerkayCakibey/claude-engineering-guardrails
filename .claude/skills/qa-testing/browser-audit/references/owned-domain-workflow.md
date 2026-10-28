# Owned Domain Browser Audit Workflow

Use this workflow when a browser-visible change needs evidence from the owned public targets:

- `https://akay.example.com`
- `https://juice.example.com`

The goal is a small, repeatable smoke audit, not a full public monitoring system. Keep generated reports and screenshots out of git.

## Preset

Use `audit` mode with all three built-in viewports, a small crawl bound, and explicit `/tmp` artifact paths:

```bash
node .claude/skills/browser-audit/scripts/run_browser_audit.js --url https://akay.example.com --mode audit --viewport all --max-pages 3 --max-depth 2 --cache-mode bust --out-dir /tmp/browser-audit-akay --screenshots-dir /tmp/browser-audit-akay/screenshots --format both
```

```bash
node .claude/skills/browser-audit/scripts/run_browser_audit.js --url https://juice.example.com --mode audit --viewport all --max-pages 3 --max-depth 2 --cache-mode bust --out-dir /tmp/browser-audit-juice --screenshots-dir /tmp/browser-audit-juice/screenshots --format both
```

Increase `--max-pages` only when a change spans more than the first few pages. Use `--cache-mode no-cache` instead of `bust` when third-party analytics preflight noise is more distracting than stale-cache risk.

## Evidence To Read

For each target, inspect:

- `/tmp/browser-audit-*/summary.md`
- `/tmp/browser-audit-*/report.json`
- `/tmp/browser-audit-*/report.html`
- `/tmp/browser-audit-*/screenshots/<viewport>/`
- `/tmp/browser-audit-*/logs/console.jsonl`
- `/tmp/browser-audit-*/logs/network.jsonl`

Report only findings backed by these files. Mention the artifact path instead of copying artifacts into the repository.

## Interpretation Notes

- Cloudflare beacon CORS failures can appear when `--cache-mode bust` or no-cache headers trigger preflight behavior against `static.cloudflareinsights.com`. The runner records these under `noise_events` and excludes them from actionable finding counts unless the application itself depends on the beacon.
- `juice.example.com` is intentionally useful as a noisy web-app target. Overlay warnings may reflect app modals, welcome banners, or challenge UI; confirm with screenshots before treating them as product defects.
- `akay.example.com` is useful as a content-site target. Prioritize horizontal overflow, broken images, responsive navigation, and failed first-party assets.
- If Chromium fails with `sandbox_host_linux` or `Operation not permitted`, rerun in an environment that permits headless Chromium rather than changing the audit thresholds.

## Completion Gate

Before closing a browser-visible change, record:

- target URL
- command or preset used
- visited page count
- finding count by severity
- screenshot directory
- whether third-party telemetry noise was excluded from product findings
