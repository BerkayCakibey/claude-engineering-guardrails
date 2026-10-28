# Report Schema

`run.json`

```json
{
  "target_url": "string",
  "mode": "capture|walk|audit",
  "viewport": "mobile|tablet|desktop|all",
  "screenshot_mode": "fullpage|viewport",
  "scroll_prime": "auto|off",
  "interaction_profile": "common|off",
  "cache_mode": "default|no-cache|bust",
  "include_paths": ["string"],
  "exclude_paths": ["string"],
  "run_status": "success|partial|failed",
  "started_at": "ISO-8601",
  "finished_at": "ISO-8601",
  "exit_code": 0,
  "out_dir": "string",
  "screenshots_dir": "string"
}
```

`report.json`

```json
{
  "target_url": "string",
  "mode": "capture|walk|audit",
  "run_status": "success|partial|failed",
  "started_at": "ISO-8601",
  "finished_at": "ISO-8601",
  "filters": {
    "include_paths": ["string"],
    "exclude_paths": ["string"]
  },
  "visited_pages": [
    {
      "url": "string",
      "title": "string",
      "depth": 0,
      "source": "seed|header-nav|main|aside|footer"
    }
  ],
  "viewport_results": [
    {
      "page_url": "string",
      "viewport": "mobile|tablet|desktop",
      "width": 1440,
      "height": 900,
      "screenshot_path": "string",
      "state_screenshots": ["string"],
      "horizontal_overflow": false,
      "oversized_elements_count": 0,
      "broken_images_count": 0,
      "overlay_obstruction_count": 0
    }
  ],
  "findings": [
    {
      "severity": "info|warning|error",
      "type": "string",
      "page_url": "string",
      "viewport": "mobile|tablet|desktop|null",
      "message": "string",
      "selector": "string|null",
      "evidence": {}
    }
  ],
  "noise_events": [
    {
      "kind": "console|network",
      "page_url": "string",
      "message": "string",
      "source": "string",
      "reason": "string",
      "evidence": {}
    }
  ],
  "console_summary": {
    "errors": 0,
    "warnings": 0,
    "messages": 0
  },
  "network_summary": {
    "failed_requests": 0,
    "status_4xx": 0,
    "status_5xx": 0
  },
  "noise_summary": {
    "telemetry": 0,
    "console": 0,
    "network": 0
  },
  "artifacts": {
    "summary_md": "string|null",
    "report_html": "string|null",
    "screenshots_dir": "string",
    "console_log": "string",
    "network_log": "string"
  }
}
```

Screenshot naming convention:

```text
<index>_<slug>_<viewport>.png
```

Default screenshot mode:

- `fullpage`
  Capture the full scrollable document.
- `viewport`
  Capture only the visible viewport.

Default state preparation:

- `scroll-prime: auto`
  Scroll through the page before capture so lazy-loaded sections have a chance to render.
- `interaction-profile: common`
  Capture extra viewport screenshots for common interaction states such as journey scroll position, opened menus, and expanded disclosures when safely detectable.
