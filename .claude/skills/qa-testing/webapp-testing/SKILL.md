---
name: webapp-testing
description: Drive local webapps with Playwright — verify UI behavior, capture screenshots, read console output, and run end-to-end flows. Use when the user wants to exercise a running frontend or reproduce a browser bug against local code.
---

# Skill: webapp-testing

## Purpose
Exercise a local webapp in a real browser to verify UI behavior, capture evidence, and reproduce browser bugs against local code.

Default to **headless Chromium + sync Playwright** unless the user needs otherwise.

## When To Use

- The user wants Playwright-driven browser testing against a local frontend.
- The task needs screenshots, console output, DOM inspection, or end-to-end flow evidence.
- The target needs one or more local dev servers started and torn down around the automation run.

## Do Not Use When

- A deployed-site crawl or same-origin browser audit is enough. Use `browser-audit`.
- The task is browser-visible QA without custom local flow authoring. Use `qa`, `qa-only`, or `click-path-audit`.
- The task is design or implementation planning rather than browser execution. Use `test-strategy-planner`.

## Workflow

1. Decide before coding:
   - **Is the page already served?** If no, you need a server lifecycle.
   - **Is the markup static or rendered by JS?** Static -> read the `.html` off disk first. JS-rendered -> connect first, wait for `networkidle`, then snapshot the DOM.
2. Run `python scripts/with_server.py --help` before reading helper source. Treat scripts in `scripts/` as black boxes.
3. Observe rendered truth before choosing selectors. Do **not** guess what the UI "probably" looks like.
4. Write the smallest Playwright flow that reproduces the issue or proves the behavior.
5. Prefer accessibility selectors and event-driven waits.
6. Close the browser explicitly and let the helper own local server cleanup.

## Script Entry Points

| Script | Purpose |
|---|---|
| `scripts/with_server.py` | Start one or more dev servers, wait for port(s), run your automation, tear down cleanly |

Single server:
```bash
python scripts/with_server.py --server "npm run dev" --port 5173 -- python flow.py
```

Multi-server (API + UI):
```bash
python scripts/with_server.py \
  --server "cd api && python server.py" --port 3000 \
  --server "cd web && npm run dev" --port 5173 \
  -- python flow.py
```

Your `flow.py` should only contain Playwright logic. The helper owns process lifecycle.

## Playwright Skeleton

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto("http://localhost:5173")
    page.wait_for_load_state("networkidle")  # non-negotiable for SPAs
    # interaction + assertions go here
    browser.close()
```

## Artifact And Output Locations

- Save evidence under a task-local temp directory such as `/tmp/webapp-testing-<slug>/`.
- Typical artifacts are `state.png`, `dom.html`, `console.jsonl`, and the flow script used for reproduction.
- `scripts/with_server.py` manages server processes only. Artifact paths belong in the flow script or its wrapper command.

## Validation Path

- `python scripts/with_server.py --help`
- Run the automation once against the local target and confirm server startup, browser navigation, evidence capture or assertions, and clean teardown.
- Reuse the bundled examples when the scenario matches instead of inventing a new pattern from scratch.

## Selector And Wait Rules

1. `page.screenshot(path="/tmp/state.png", full_page=True)` — visual ground truth.
2. `page.content()` — full rendered HTML once idle.
3. `page.get_by_role(...)` / `page.get_by_text(...)` — prefer accessibility selectors over CSS when available.
4. Only fall back to CSS/XPath when role/text does not disambiguate.

| Situation | Wait |
|---|---|
| SPA navigation, async fetches | `page.wait_for_load_state("networkidle")` |
| Specific element to appear | `page.wait_for_selector("...")` |
| A URL change | `page.wait_for_url(...)` |
| Fixed delay | Avoid. Use a condition. |

`page.wait_for_timeout()` is a smell. Prefer event-driven waits.

## Non-Goals And Safety Notes

- Do not guess selectors before observing the rendered page.
- Do not read the DOM before `networkidle` on dynamic apps.
- Do not default to headed Chromium in CI unless the user explicitly needs it.
- Do not point helper-managed server commands at remote or production-like environments.
- Do not leave browsers or helper-managed servers running after the task.

## Support Assets

- `scripts/with_server.py` — local server lifecycle helper.
- `examples/element_discovery.py` — enumerate interactive elements on a rendered page.
- `examples/static_html_automation.py` — `file://` URL pattern for local HTML.
- `examples/console_logging.py` — capture `console.*` output during a run.
