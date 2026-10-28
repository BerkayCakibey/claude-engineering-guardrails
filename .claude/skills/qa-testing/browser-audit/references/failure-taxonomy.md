# Failure Taxonomy

## Run Failures

- `invalid-args`
  Missing or invalid CLI arguments.
- `browser-launch-failed`
  Playwright browser could not start.
- `navigation-failed`
  Initial target or a selected page could not be opened.
- `artifact-write-failed`
  Output files or directories could not be written.
- `internal-error`
  Unexpected runner exception.

## Findings

- `console-error`
  Browser console emitted an error.
- `console-warning`
  Browser console emitted a warning.
- `failed-request`
  Network request failed entirely.
- `http-4xx`
  Response status code in the 4xx range.
- `http-5xx`
  Response status code in the 5xx range.
- `horizontal-overflow`
  `document.documentElement.scrollWidth > window.innerWidth + 4`
- `oversized-element`
  Element overflows viewport width by more than `24px`
- `broken-image`
  `img.complete && img.naturalWidth === 0`
- `overlay-obstruction`
  Fixed or sticky element with height greater than `18%` of viewport height and overlapping the viewport center line.

## Noise Events

- `cloudflare-insights`
  Known third-party telemetry noise from `static.cloudflareinsights.com`. Cache-bust or no-cache audit runs can trigger beacon CORS/preflight failures. These events are recorded under `noise_events` and excluded from actionable finding counts unless the product explicitly depends on the telemetry beacon.

## Severity

- `info`
  Collected evidence without direct breakage.
- `warning`
  Noticeable issue that may harm UX.
- `error`
  Strong indication of broken behavior.
