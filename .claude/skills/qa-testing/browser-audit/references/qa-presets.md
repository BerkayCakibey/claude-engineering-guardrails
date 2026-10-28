# Browser QA Presets

Use these presets when choosing how much browser evidence a task needs. They map to the existing `browser-audit` runner flags; they do not require another browser stack.

## Quick

Use for small copy, layout, or single-page checks.

```bash
node .claude/skills/browser-audit/scripts/run_browser_audit.js --url <target> --mode audit --viewport desktop --max-pages 1 --max-depth 1 --format both
```

Evidence expectation:

- one desktop screenshot
- `summary.md`
- console/network/layout findings

## Standard

Use for normal visual or responsive changes.

```bash
node .claude/skills/browser-audit/scripts/run_browser_audit.js --url <target> --mode audit --viewport all --max-pages 3 --max-depth 2 --format both
```

Evidence expectation:

- mobile, tablet, and desktop screenshots
- journey screenshots when scrollable content exists
- console/network/layout findings
- known telemetry noise separated from actionable findings

## Exhaustive

Use only when a user-facing flow, navigation model, or multi-page site changed.

```bash
node .claude/skills/browser-audit/scripts/run_browser_audit.js --url <target> --mode audit --viewport all --max-pages 10 --max-depth 3 --cache-mode bust --format both
```

Evidence expectation:

- same-origin crawl evidence
- all viewport artifacts
- cache-busted run when CDN/browser cache is suspected
- explicit note for any pages excluded by path filters or crawl limits

## Selection Rule

- Start with Quick when the blast radius is one page and one viewport.
- Use Standard for responsive or layout changes.
- Use Exhaustive only when navigation, crawlable content, or multi-page behavior changed.
