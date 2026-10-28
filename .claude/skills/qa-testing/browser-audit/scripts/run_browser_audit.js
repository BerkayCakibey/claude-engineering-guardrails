#!/usr/bin/env node

import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";

const EXIT_CODES = {
  SUCCESS: 0,
  INVALID_ARGS: 1,
  BROWSER_LAUNCH_FAILED: 2,
  NAVIGATION_FAILED: 3,
  ARTIFACT_WRITE_FAILED: 4,
  INTERNAL_ERROR: 5,
};

const VIEWPORT_ORDER = ["mobile", "tablet", "desktop"];
const LINK_SOURCES = [
  { source: "header-nav", selectors: ["header a", "nav a"] },
  { source: "main", selectors: ["main a"] },
  { source: "aside", selectors: ["aside a"] },
  { source: "footer", selectors: ["footer a"] },
];
const BLOCKED_PATTERNS = [/logout/i, /signout/i, /login/i, /signin/i, /account/i];
const ALLOWED_MODES = new Set(["capture", "walk", "audit"]);
const ALLOWED_VIEWPORTS = new Set(["mobile", "tablet", "desktop", "all"]);
const ALLOWED_WAIT_UNTIL = new Set(["load", "domcontentloaded", "networkidle"]);
const ALLOWED_FORMATS = new Set(["json", "md", "html", "both"]);
const ALLOWED_SCREENSHOT_MODES = new Set(["fullpage", "viewport"]);
const ALLOWED_SCROLL_PRIME = new Set(["auto", "off"]);
const ALLOWED_INTERACTION_PROFILES = new Set(["common", "off"]);
const ALLOWED_CACHE_MODES = new Set(["default", "no-cache", "bust"]);
const DEFAULT_ARTIFACT_ROOT =
  process.env.CLAUDE_ENGINEERING_GUARDRAILS_BROWSER_AUDIT_ROOT ??
  path.join(process.env.HOME ?? "/tmp", ".claude", "skills", "browser-audit", "artifacts");
const KNOWN_TELEMETRY_HOSTS = new Map([
  [
    "static.cloudflareinsights.com",
    {
      source: "cloudflare-insights",
      reason: "Cloudflare beacon can reject no-cache/cache-bust preflight headers.",
    },
  ],
]);
const GENERIC_RESOURCE_FAILURE_MESSAGES = new Set(["Failed to load resource: net::ERR_FAILED"]);

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const item = argv[i];
    if (item === "--help" || item === "-h") {
      args.help = "true";
      continue;
    }
    if (item === "--self-test") {
      args.selfTest = "true";
      continue;
    }
    if (!item.startsWith("--")) {
      throw new Error(`Unexpected argument: ${item}`);
    }
    const key = item.slice(2);
    const value = argv[i + 1];
    if (!value || value.startsWith("--")) {
      throw new Error(`Missing value for --${key}`);
    }
    args[key] = value;
    i += 1;
  }
  return args;
}

function renderHelp() {
  return `browser-audit

Usage:
  node scripts/run_browser_audit.js --url <target> [options]

Required:
  --url <target>                      Target URL to open

Modes:
  --mode capture|walk|audit          Default: audit

Viewport:
  --viewport mobile|tablet|desktop|all
                                      Default: desktop

Screenshots:
  --screenshot-mode fullpage|viewport
                                      Default: fullpage
  --scroll-prime auto|off            Default: auto
  --interaction-profile common|off   Default: common
  --cache-mode default|no-cache|bust Default: default

Crawl:
  --max-pages <n>                    Default: 10
  --max-depth <n>                    Default: 10
  --include-path <csv>               Optional same-origin path allowlist
  --exclude-path <csv>               Optional same-origin path denylist

Loading:
  --wait-until load|domcontentloaded|networkidle
                                      Default: networkidle
  --timeout <ms>                     Default: 15000

Output:
  --out-dir <artifact-dir>           WSL report/log directory
  --screenshots-dir <image-dir>      Screenshot directory
  --format json|md|html|both         Default: both

Diagnostics:
  --self-test                        Run lightweight runner self-tests without opening a browser

Defaults:
  Desktop audit, same-origin crawl, full-page screenshots, lazy-load scroll priming,
  and common interaction state capture.

Examples:
  node scripts/run_browser_audit.js --self-test
  node scripts/run_browser_audit.js --url https://example.com
  node scripts/run_browser_audit.js --url https://example.com --viewport mobile
  node scripts/run_browser_audit.js --url https://example.com --viewport all --mode audit
  node scripts/run_browser_audit.js --url https://example.com --screenshot-mode viewport
  node scripts/run_browser_audit.js --url https://example.com --interaction-profile off
  node scripts/run_browser_audit.js --url https://example.com --include-path /blog,/docs --exclude-path /docs/private
  node scripts/run_browser_audit.js --url https://example.com --cache-mode bust
`;
}

function normalizeUrl(rawUrl) {
  const url = new URL(rawUrl);
  url.hash = "";
  if (!url.pathname) {
    url.pathname = "/";
  }
  if (url.pathname === "/index.html" || url.pathname === "/index.htm") {
    url.pathname = "/";
  }
  return url;
}

function slugFromUrl(urlString) {
  const url = new URL(urlString);
  const raw = url.pathname === "/" ? "home" : url.pathname.replace(/^\/+|\/+$/g, "").replaceAll("/", "-");
  return raw.replace(/[^a-zA-Z0-9-_]+/g, "-").replace(/-+/g, "-").replace(/^-|-$/g, "").toLowerCase() || "page";
}

function buildRunId(targetUrl) {
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  return `${slugFromUrl(targetUrl)}-${stamp}`;
}

function buildDefaultDirs(targetUrl) {
  const runId = buildRunId(targetUrl);
  return {
    runId,
    reportDir: path.join(DEFAULT_ARTIFACT_ROOT, runId),
    screenshotsDir: path.join(DEFAULT_ARTIFACT_ROOT, runId, "screenshots"),
  };
}

async function readViewports(skillRoot) {
  const content = await fs.readFile(path.join(skillRoot, "references", "viewports.json"), "utf8");
  return JSON.parse(content);
}

function resolveViewportKeys(viewport) {
  if (viewport === "all") {
    return [...VIEWPORT_ORDER];
  }
  return [viewport];
}

function getCrawlViewportKey(viewport, viewportKeys) {
  if (viewport === "all") {
    return "desktop";
  }
  return viewportKeys[0];
}

function buildContextOptions(viewportConfig) {
  return {
    viewport: {
      width: viewportConfig.width,
      height: viewportConfig.height,
    },
    deviceScaleFactor: viewportConfig.deviceScaleFactor,
    isMobile: viewportConfig.isMobile,
    hasTouch: viewportConfig.hasTouch,
  };
}

function applyCacheMode(targetUrl, cacheMode) {
  if (cacheMode !== "bust") {
    return targetUrl;
  }
  const url = new URL(targetUrl);
  url.searchParams.set("__ba_ts", Date.now().toString());
  return url.toString();
}

function buildCacheContextOptions(cacheMode) {
  if (cacheMode === "no-cache" || cacheMode === "bust") {
    return {
      extraHTTPHeaders: {
        "Cache-Control": "no-cache, no-store, max-age=0",
        Pragma: "no-cache",
      },
      serviceWorkers: "block",
    };
  }
  return {};
}

async function ensureDir(dirPath) {
  await fs.mkdir(dirPath, { recursive: true });
}

async function writeJson(filePath, value) {
  await fs.writeFile(filePath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
}

async function appendJsonl(filePath, value) {
  await fs.appendFile(filePath, `${JSON.stringify(value)}\n`, "utf8");
}

function parseCsvPatterns(value) {
  if (!value) {
    return [];
  }
  return value
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);
}

function matchesPathPattern(pathname, pattern) {
  if (!pattern) {
    return false;
  }
  const normalizedPattern = pattern.startsWith("/") ? pattern : `/${pattern}`;
  const canonicalPattern =
    normalizedPattern !== "/" && normalizedPattern.endsWith("/")
      ? normalizedPattern.slice(0, -1)
      : normalizedPattern;
  if (canonicalPattern === "/") {
    return pathname === "/";
  }
  return (
    pathname === canonicalPattern ||
    pathname.startsWith(`${canonicalPattern}/`) ||
    pathname.startsWith(`${canonicalPattern}.`)
  );
}

function isPathAllowed(url, includePatterns, excludePatterns) {
  if (excludePatterns.some((pattern) => matchesPathPattern(url.pathname, pattern))) {
    return false;
  }
  if (includePatterns.length === 0) {
    return true;
  }
  return includePatterns.some((pattern) => matchesPathPattern(url.pathname, pattern));
}

function makeFinding(severity, type, pageUrl, viewport, message, selector = null, evidence = {}) {
  return { severity, type, page_url: pageUrl, viewport, message, selector, evidence };
}

function makeNoiseEvent(kind, pageUrl, message, source, reason, evidence = {}) {
  return { kind, page_url: pageUrl, message, source, reason, evidence };
}

function classifyKnownTelemetryNoiseFromUrl(urlString) {
  try {
    const url = new URL(urlString);
    return KNOWN_TELEMETRY_HOSTS.get(url.hostname) ?? null;
  } catch {
    return null;
  }
}

function classifyKnownTelemetryNoiseFromText(text) {
  for (const [host, classification] of KNOWN_TELEMETRY_HOSTS) {
    if (text.includes(host)) {
      return classification;
    }
  }
  return null;
}

function classifyConsoleTelemetryNoise(text, locationUrl, pageUrl, telemetryNoiseByPage) {
  return (
    classifyKnownTelemetryNoiseFromText(text) ??
    classifyKnownTelemetryNoiseFromUrl(locationUrl) ??
    (GENERIC_RESOURCE_FAILURE_MESSAGES.has(text) ? (telemetryNoiseByPage.get(pageUrl) ?? null) : null)
  );
}

function parseBoundedInteger(rawValue, name, min, max) {
  const text = String(rawValue);
  if (!/^\d+$/.test(text)) {
    throw new Error(`Invalid --${name}: expected an integer between ${min} and ${max}`);
  }
  const value = Number.parseInt(text, 10);
  if (!Number.isSafeInteger(value) || value < min || value > max) {
    throw new Error(`Invalid --${name}: expected an integer between ${min} and ${max}`);
  }
  return value;
}

function assertSelfTest(condition, message) {
  if (!condition) {
    throw new Error(`self-test failed: ${message}`);
  }
}

function assertSelfTestThrows(fn, message) {
  let threw = false;
  try {
    fn();
  } catch {
    threw = true;
  }
  assertSelfTest(threw, message);
}

function runSelfTest() {
  assertSelfTest(parseBoundedInteger("1", "max-pages", 1, 1000) === 1, "parses valid bounded integers");
  assertSelfTest(parseBoundedInteger("0", "max-depth", 0, 50) === 0, "allows zero-depth crawls");
  assertSelfTestThrows(() => parseBoundedInteger("0", "max-pages", 1, 1000), "rejects zero max-pages");
  assertSelfTestThrows(() => parseBoundedInteger("1.5", "max-pages", 1, 1000), "rejects decimal max-pages");
  assertSelfTestThrows(() => parseBoundedInteger("abc", "timeout", 1, 120000), "rejects non-numeric timeout");

  const cloudflareUrl = "https://static.cloudflareinsights.com/beacon.min.js/v123";
  const cloudflare = classifyKnownTelemetryNoiseFromUrl(cloudflareUrl);
  assertSelfTest(cloudflare?.source === "cloudflare-insights", "classifies Cloudflare telemetry URLs");
  assertSelfTest(
    classifyKnownTelemetryNoiseFromText(`Access to script at '${cloudflareUrl}' was blocked`)?.source ===
      "cloudflare-insights",
    "classifies Cloudflare telemetry console text",
  );
  assertSelfTest(
    classifyConsoleTelemetryNoise(
      "Failed to load resource: net::ERR_FAILED",
      cloudflareUrl,
      "https://example.test/",
      new Map(),
    )?.source === "cloudflare-insights",
    "classifies generic console failures from console location URLs",
  );

  const telemetryNoiseByPage = new Map([["https://example.test/", cloudflare]]);
  assertSelfTest(
    classifyConsoleTelemetryNoise(
      "Failed to load resource: net::ERR_FAILED",
      "",
      "https://example.test/",
      telemetryNoiseByPage,
    )?.source === "cloudflare-insights",
    "classifies generic console failures from page-level telemetry context",
  );
  assertSelfTest(
    classifyConsoleTelemetryNoise(
      "Failed to load resource: net::ERR_FAILED",
      "",
      "https://other.test/",
      telemetryNoiseByPage,
    ) === null,
    "does not classify unrelated generic console failures",
  );

  const report = {
    noise_events: [],
    noise_summary: { telemetry: 0, console: 0, network: 0 },
  };
  const dedupe = new Set();
  const event = makeNoiseEvent(
    "console",
    "https://example.test/",
    "Failed to load resource: net::ERR_FAILED",
    cloudflare.source,
    cloudflare.reason,
  );
  addNoiseEvent(report, dedupe, event);
  addNoiseEvent(report, dedupe, event);
  assertSelfTest(report.noise_summary.telemetry === 1, "deduplicates telemetry noise events");
  assertSelfTest(report.noise_summary.console === 1, "counts console telemetry noise events");

  console.log("[OK] browser-audit self-test passed");
}

function shouldSkipUrl(url) {
  if (url.protocol !== "http:" && url.protocol !== "https:") {
    return true;
  }
  if (url.search && url.search.length > 32) {
    return true;
  }
  return BLOCKED_PATTERNS.some((pattern) => pattern.test(`${url.pathname}${url.search}`));
}

function findingSignature(finding) {
  return JSON.stringify([
    finding.severity,
    finding.type,
    finding.page_url,
    finding.viewport,
    finding.message,
    finding.selector,
    finding.evidence,
  ]);
}

function addFinding(report, dedupeSet, finding) {
  const signature = findingSignature(finding);
  if (dedupeSet.has(signature)) {
    return;
  }
  dedupeSet.add(signature);
  report.findings.push(finding);
}

function noiseEventSignature(event) {
  return JSON.stringify([event.kind, event.page_url, event.message, event.source, event.evidence]);
}

function addNoiseEvent(report, dedupeSet, event) {
  const signature = noiseEventSignature(event);
  if (dedupeSet.has(signature)) {
    return;
  }
  dedupeSet.add(signature);
  report.noise_events.push(event);
  report.noise_summary.telemetry += 1;
  if (event.kind === "console") {
    report.noise_summary.console += 1;
  } else if (event.kind === "network") {
    report.noise_summary.network += 1;
  }
}

async function collectCandidateLinks(page, origin, includePatterns, excludePatterns) {
  const seen = new Set();
  const collected = [];

  for (const entry of LINK_SOURCES) {
    for (const selector of entry.selectors) {
      const links = await page.locator(selector).evaluateAll((elements) =>
        elements.map((element) => {
          const anchor = element;
          const rect = anchor.getBoundingClientRect();
          const style = window.getComputedStyle(anchor);
          return {
            href: anchor.href,
            text: anchor.textContent?.trim() || "",
            visible:
              rect.width > 0 &&
              rect.height > 0 &&
              style.visibility !== "hidden" &&
              style.display !== "none",
          };
        }),
      );

      for (const link of links) {
        if (!link.visible || !link.href) {
          continue;
        }
        const url = normalizeUrl(link.href);
        if (
          url.origin !== origin ||
          shouldSkipUrl(url) ||
          !isPathAllowed(url, includePatterns, excludePatterns)
        ) {
          continue;
        }
        const normalized = url.toString();
        if (seen.has(normalized)) {
          continue;
        }
        seen.add(normalized);
        collected.push({ url: normalized, source: entry.source });
      }
    }
  }

  return collected;
}

async function openCommonNavigation(page) {
  const selectors = [
    "button[aria-label*='menu' i]",
    "button[aria-haspopup='menu']",
    "[aria-controls][aria-expanded='false']",
  ];

  for (const selector of selectors) {
    const locator = page.locator(selector).first();
    try {
      if (!(await locator.isVisible({ timeout: 250 }))) {
        continue;
      }
      await locator.click({ timeout: 1000 });
      await page.waitForTimeout(250);
      return true;
    } catch {
      // Best-effort navigation expansion.
    }
  }

  return false;
}

async function inspectLayout(page) {
  return page.evaluate(() => {
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;
    const horizontalOverflow = document.documentElement.scrollWidth > viewportWidth + 4;
    const oversized = [];
    const brokenImages = [];
    const overlays = [];

    for (const element of document.body.querySelectorAll("*")) {
      const rect = element.getBoundingClientRect();
      if (rect.width <= 0 || rect.height <= 0) {
        continue;
      }
      const overflow = rect.right - viewportWidth;
      if (overflow > 24) {
        oversized.push({
          selector: element.tagName.toLowerCase(),
          overflow,
          width: rect.width,
        });
      }

      const style = window.getComputedStyle(element);
      const isOverlay = ["fixed", "sticky"].includes(style.position);
      const coversCenter = rect.top <= viewportHeight / 2 && rect.bottom >= viewportHeight / 2;
      if (isOverlay && coversCenter && rect.height > viewportHeight * 0.18) {
        overlays.push({
          selector: element.tagName.toLowerCase(),
          height: rect.height,
        });
      }
    }

    for (const image of document.images) {
      if (image.complete && image.naturalWidth === 0) {
        brokenImages.push({
          src: image.currentSrc || image.src,
          alt: image.alt || "",
        });
      }
    }

    return {
      horizontalOverflow,
      oversized,
      brokenImages,
      overlays,
    };
  });
}

async function dismissCommonOverlays(page) {
  const selectors = [
    "#onetrust-accept-btn-handler",
    ".onetrust-close-btn-handler",
    "[aria-label*='cookie' i]",
    "[aria-label*='consent' i]",
    "[data-testid*='cookie' i] button",
    "[id*='cookie' i] button",
    "[class*='cookie' i] button",
    "[class*='consent' i] button",
    "button:has-text('Accept')",
    "button:has-text('Accept all')",
    "button:has-text('Allow all')",
    "button:has-text('I agree')",
    "button:has-text('Tamam')",
    "button:has-text('Kabul et')",
    "button:has-text('Kabul Et')",
  ];

  let dismissed = 0;
  for (const selector of selectors) {
    const locator = page.locator(selector).first();
    try {
      if (await locator.isVisible({ timeout: 250 })) {
        await locator.click({ timeout: 1000 });
        dismissed += 1;
        await page.waitForTimeout(250);
      }
    } catch {
      // Best-effort overlay dismissal.
    }
  }
  return dismissed;
}

async function primePageByScrolling(page) {
  return page.evaluate(async () => {
    const step = Math.max(200, Math.floor(window.innerHeight * 0.75));
    const sleep = (ms) => new Promise((resolve) => window.setTimeout(resolve, ms));
    let iterations = 0;
    let lastHeight = 0;

    while (iterations < 40) {
      const scrollHeight = Math.max(
        document.documentElement.scrollHeight,
        document.body.scrollHeight,
      );
      window.scrollBy(0, step);
      await sleep(180);
      iterations += 1;
      const reachedBottom = window.scrollY + window.innerHeight >= scrollHeight - 4;
      if (reachedBottom) {
        if (scrollHeight === lastHeight) {
          break;
        }
        lastHeight = scrollHeight;
      }
    }

    window.scrollTo(0, 0);
    await sleep(180);
    return {
      iterations,
      scrollHeight: Math.max(
        document.documentElement.scrollHeight,
        document.body.scrollHeight,
      ),
    };
  });
}

async function collectStateScreenshots(
  page,
  viewportDir,
  baseStem,
  interactionProfile,
) {
  const stateScreenshots = [];

  const saveViewportState = async (suffix) => {
    const statePath = path.join(viewportDir, `${baseStem}_${suffix}.png`);
    await page.screenshot({ path: statePath, fullPage: false });
    stateScreenshots.push(statePath);
  };

  const pageMetrics = await page.evaluate(() => ({
    scrollHeight: Math.max(
      document.documentElement.scrollHeight,
      document.body.scrollHeight,
    ),
    viewportHeight: window.innerHeight,
  }));

  if (pageMetrics.scrollHeight > pageMetrics.viewportHeight + 200) {
    await page.evaluate(() => window.scrollTo(0, Math.max(0, Math.floor(window.innerHeight * 0.75))));
    await page.waitForTimeout(250);
    await saveViewportState("journey");
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(150);
  }

  if (interactionProfile === "off") {
    return stateScreenshots;
  }

  const actionCandidates = [
    {
      suffix: "menu-open",
      selectors: [
        "button[aria-label*='menu' i]",
        "[aria-controls][aria-expanded='false']",
        "button[aria-haspopup='menu']",
      ],
    },
    {
      suffix: "disclosure-open",
      selectors: [
        "summary",
        "button[aria-expanded='false']",
        "[role='button'][aria-expanded='false']",
      ],
    },
  ];

  for (const candidate of actionCandidates) {
    let captured = false;
    for (const selector of candidate.selectors) {
      const locator = page.locator(selector).first();
      try {
        if (!(await locator.isVisible({ timeout: 250 }))) {
          continue;
        }
        await locator.click({ timeout: 1000 });
        await page.waitForTimeout(250);
        await saveViewportState(candidate.suffix);
        captured = true;
        break;
      } catch {
        // Best-effort common interaction probing.
      }
    }
    if (captured) {
      await page.evaluate(() => window.scrollTo(0, 0));
      await page.waitForTimeout(150);
    }
  }

  return stateScreenshots;
}

async function captureViewportArtifact(
  browser,
  targetUrl,
  viewports,
  viewportKey,
  waitUntil,
  timeout,
  screenshotsDir,
  screenshotName,
  screenshotMode,
  scrollPrime,
  interactionProfile,
  cacheMode,
) {
  const viewportConfig = viewports[viewportKey];
  const context = await browser.newContext({
    ...buildContextOptions(viewportConfig),
    ...buildCacheContextOptions(cacheMode),
  });

  try {
    const page = await context.newPage();
    page.setDefaultTimeout(timeout);
    page.setDefaultNavigationTimeout(timeout);
    await page.goto(applyCacheMode(targetUrl, cacheMode), { waitUntil });
    await dismissCommonOverlays(page);
    if (scrollPrime === "auto") {
      await primePageByScrolling(page);
    }

    const viewportDir = path.join(screenshotsDir, viewportKey);
    await ensureDir(viewportDir);
    const screenshotPath = path.join(viewportDir, screenshotName);
    await page.screenshot({
      path: screenshotPath,
      fullPage: screenshotMode === "fullpage",
    });
    const baseStem = screenshotName.replace(/\.png$/i, "");
    const stateScreenshots = await collectStateScreenshots(
      page,
      viewportDir,
      baseStem,
      interactionProfile,
    );

    const layout = await inspectLayout(page);
    return {
      screenshotPath,
      stateScreenshots,
      layout,
      width: viewportConfig.width,
      height: viewportConfig.height,
    };
  } finally {
    await context.close();
  }
}

async function launchChromium() {
  const { chromium } = await import("playwright");
  return chromium.launch({ headless: true });
}

function renderSummary(report) {
  const findingsBlock =
    report.findings.length === 0
      ? "- No findings"
      : report.findings
          .map((finding) => `- [${finding.severity}] ${finding.type} :: ${finding.page_url}${finding.viewport ? ` (${finding.viewport})` : ""} - ${finding.message}`)
          .join("\n");

  return `# Browser Audit Summary

- Target: \`${report.target_url}\`
- Mode: \`${report.mode}\`
- Status: \`${report.run_status}\`
- Started: \`${report.started_at}\`
- Finished: \`${report.finished_at}\`
- Visited pages: \`${report.visited_pages.length}\`
- Findings: \`${report.findings.length}\`
- Telemetry noise: \`${report.noise_summary.telemetry}\`
- Console errors/warnings: \`${report.console_summary.errors}\` / \`${report.console_summary.warnings}\`
- Failed requests: \`${report.network_summary.failed_requests}\`
- HTTP 4xx / 5xx: \`${report.network_summary.status_4xx}\` / \`${report.network_summary.status_5xx}\`

## Findings

${findingsBlock}
`;
}

function renderHtmlReport(report) {
  const escape = (value) =>
    String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;");
  const findings = report.findings
    .map(
      (finding) =>
        `<tr><td>${escape(finding.severity)}</td><td>${escape(finding.type)}</td><td>${escape(finding.page_url)}</td><td>${escape(finding.viewport ?? "-")}</td><td>${escape(finding.message)}</td></tr>`,
    )
    .join("");
  const noiseEvents = report.noise_events
    .map(
      (event) =>
        `<tr><td>${escape(event.kind)}</td><td>${escape(event.source)}</td><td>${escape(event.page_url)}</td><td>${escape(event.message)}</td><td>${escape(event.reason)}</td></tr>`,
    )
    .join("");
  const pages = report.viewport_results
    .map((entry) => {
      const states = (entry.state_screenshots ?? [])
        .map((item) => `<li><a href="${escape(item)}">${escape(path.basename(item))}</a></li>`)
        .join("");
      return `<section><h3>${escape(entry.page_url)} (${escape(entry.viewport)})</h3><p><a href="${escape(entry.screenshot_path)}">${escape(path.basename(entry.screenshot_path))}</a></p><ul>${states}</ul></section>`;
    })
    .join("");

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Browser Audit Report</title>
  <style>
    body { font-family: system-ui, sans-serif; margin: 2rem; color: #111827; }
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #d1d5db; padding: 0.5rem; text-align: left; vertical-align: top; }
    th { background: #f3f4f6; }
    section { margin-top: 1.5rem; }
    code { background: #f3f4f6; padding: 0.1rem 0.3rem; }
  </style>
</head>
<body>
  <h1>Browser Audit Report</h1>
  <p><strong>Target:</strong> <code>${escape(report.target_url)}</code></p>
  <p><strong>Mode:</strong> <code>${escape(report.mode)}</code></p>
  <p><strong>Status:</strong> <code>${escape(report.run_status)}</code></p>
  <p><strong>Visited pages:</strong> ${report.visited_pages.length}</p>
  <p><strong>Findings:</strong> ${report.findings.length}</p>
  <p><strong>Telemetry noise:</strong> ${report.noise_summary.telemetry}</p>
  <h2>Findings</h2>
  <table>
    <thead>
      <tr><th>Severity</th><th>Type</th><th>Page</th><th>Viewport</th><th>Message</th></tr>
    </thead>
    <tbody>${findings || "<tr><td colspan='5'>No findings</td></tr>"}</tbody>
  </table>
  <h2>Noise Events</h2>
  <table>
    <thead>
      <tr><th>Kind</th><th>Source</th><th>Page</th><th>Message</th><th>Reason</th></tr>
    </thead>
    <tbody>${noiseEvents || "<tr><td colspan='5'>No noise events</td></tr>"}</tbody>
  </table>
  <h2>Screenshots</h2>
  ${pages}
</body>
</html>
`;
}

async function main() {
  const skillRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
  const rawArgs = parseArgs(process.argv);
  if (rawArgs.help === "true") {
    console.log(renderHelp());
    process.exitCode = EXIT_CODES.SUCCESS;
    return;
  }
  if (rawArgs.selfTest === "true") {
    runSelfTest();
    process.exitCode = EXIT_CODES.SUCCESS;
    return;
  }
  const url = rawArgs.url;
  const mode = rawArgs.mode ?? "audit";
  const viewport = rawArgs.viewport ?? "desktop";
  const waitUntil = rawArgs["wait-until"] ?? "networkidle";
  const format = rawArgs.format ?? "both";
  const screenshotMode = rawArgs["screenshot-mode"] ?? "fullpage";
  const scrollPrime = rawArgs["scroll-prime"] ?? "auto";
  const interactionProfile = rawArgs["interaction-profile"] ?? "common";
  const cacheMode = rawArgs["cache-mode"] ?? "default";
  const includePatterns = parseCsvPatterns(rawArgs["include-path"]);
  const excludePatterns = parseCsvPatterns(rawArgs["exclude-path"]);

  if (
    !url ||
    !ALLOWED_MODES.has(mode) ||
    !ALLOWED_VIEWPORTS.has(viewport) ||
    !ALLOWED_WAIT_UNTIL.has(waitUntil) ||
    !ALLOWED_FORMATS.has(format) ||
    !ALLOWED_SCREENSHOT_MODES.has(screenshotMode) ||
    !ALLOWED_SCROLL_PRIME.has(scrollPrime) ||
    !ALLOWED_INTERACTION_PROFILES.has(interactionProfile) ||
    !ALLOWED_CACHE_MODES.has(cacheMode)
  ) {
    process.exitCode = EXIT_CODES.INVALID_ARGS;
    console.error(renderHelp());
    throw new Error("Invalid or missing required arguments");
  }

  let maxPages;
  let maxDepth;
  let timeout;
  try {
    maxPages = parseBoundedInteger(rawArgs["max-pages"] ?? "10", "max-pages", 1, 1000);
    maxDepth = parseBoundedInteger(rawArgs["max-depth"] ?? "10", "max-depth", 0, 50);
    timeout = parseBoundedInteger(rawArgs.timeout ?? "15000", "timeout", 1, 120000);
  } catch (error) {
    process.exitCode = EXIT_CODES.INVALID_ARGS;
    console.error(renderHelp());
    throw error;
  }

  const targetUrl = normalizeUrl(url).toString();
  const targetOrigin = new URL(targetUrl).origin;
  const defaultDirs = buildDefaultDirs(targetUrl);
  const reportDir = path.resolve(rawArgs["out-dir"] ?? defaultDirs.reportDir);
  const screenshotsDir = path.resolve(rawArgs["screenshots-dir"] ?? defaultDirs.screenshotsDir);
  const viewports = await readViewports(skillRoot);
  const viewportKeys = resolveViewportKeys(viewport);
  const crawlViewportKey = getCrawlViewportKey(viewport, viewportKeys);
  const startedAt = new Date().toISOString();

  try {
    await ensureDir(reportDir);
    await ensureDir(path.join(reportDir, "logs"));
    await ensureDir(screenshotsDir);
  } catch (error) {
    process.exitCode = EXIT_CODES.ARTIFACT_WRITE_FAILED;
    throw error;
  }

  const consoleLogPath = path.join(reportDir, "logs", "console.jsonl");
  const networkLogPath = path.join(reportDir, "logs", "network.jsonl");

  const report = {
    target_url: targetUrl,
    mode,
    run_status: "success",
    started_at: startedAt,
    finished_at: null,
    filters: {
      include_paths: includePatterns,
      exclude_paths: excludePatterns,
    },
    visited_pages: [],
    viewport_results: [],
    findings: [],
    noise_events: [],
    console_summary: { errors: 0, warnings: 0, messages: 0 },
    network_summary: { failed_requests: 0, status_4xx: 0, status_5xx: 0 },
    noise_summary: { telemetry: 0, console: 0, network: 0 },
    artifacts: {
      summary_md: format === "json" ? null : path.join(reportDir, "summary.md"),
      report_html:
        format === "html" || format === "both"
          ? path.join(reportDir, "report.html")
          : null,
      screenshots_dir: screenshotsDir,
      console_log: consoleLogPath,
      network_log: networkLogPath,
    },
  };

  const run = {
    target_url: targetUrl,
    mode,
    viewport,
    screenshot_mode: screenshotMode,
    scroll_prime: scrollPrime,
    interaction_profile: interactionProfile,
    cache_mode: cacheMode,
    include_paths: includePatterns,
    exclude_paths: excludePatterns,
    run_status: "success",
    started_at: startedAt,
    finished_at: null,
    exit_code: EXIT_CODES.SUCCESS,
    out_dir: reportDir,
    screenshots_dir: screenshotsDir,
  };

  let browser;
  try {
    browser = await launchChromium();
  } catch (error) {
    run.run_status = "failed";
    run.exit_code = EXIT_CODES.BROWSER_LAUNCH_FAILED;
    run.finished_at = new Date().toISOString();
    await writeJson(path.join(reportDir, "run.json"), run);
    process.exitCode = EXIT_CODES.BROWSER_LAUNCH_FAILED;
    throw error;
  }

  const queue = [{ url: targetUrl, depth: 0, source: "seed" }];
  const seen = new Set();
  const findingDedupe = new Set();
  const noiseDedupe = new Set();
  const telemetryNoiseByPage = new Map();
  let pageIndex = 0;

  try {
    while (queue.length > 0 && report.visited_pages.length < maxPages) {
      const next = queue.shift();
      if (!next || seen.has(next.url)) {
        continue;
      }
      seen.add(next.url);

      const crawlContext = await browser.newContext({
        ...buildContextOptions(viewports[crawlViewportKey]),
        ...buildCacheContextOptions(cacheMode),
      });
      try {
        const page = await crawlContext.newPage();
        page.setDefaultTimeout(timeout);
        page.setDefaultNavigationTimeout(timeout);

        page.on("console", async (message) => {
          const type = message.type();
          const text = message.text();
          const payload = {
            page_url: page.url() || next.url,
            type,
            text,
            location: message.location(),
          };
          const telemetryNoise = classifyConsoleTelemetryNoise(
            text,
            payload.location?.url ?? "",
            payload.page_url,
            telemetryNoiseByPage,
          );
          if (telemetryNoise) {
            telemetryNoiseByPage.set(payload.page_url, telemetryNoise);
            addNoiseEvent(
              report,
              noiseDedupe,
              makeNoiseEvent("console", payload.page_url, text, telemetryNoise.source, telemetryNoise.reason, payload),
            );
            report.console_summary.messages += 1;
            await appendJsonl(consoleLogPath, { ...payload, noise: telemetryNoise });
            return;
          }
          if (type === "error") {
            report.console_summary.errors += 1;
            addFinding(report, findingDedupe, makeFinding("error", "console-error", payload.page_url, null, text));
          } else if (type === "warning") {
            report.console_summary.warnings += 1;
            addFinding(report, findingDedupe, makeFinding("warning", "console-warning", payload.page_url, null, text));
          }
          report.console_summary.messages += 1;
          await appendJsonl(consoleLogPath, payload);
        });

        page.on("requestfailed", async (request) => {
          const payload = {
            page_url: page.url() || next.url,
            url: request.url(),
            method: request.method(),
            error_text: request.failure()?.errorText ?? "unknown",
          };
          const telemetryNoise = classifyKnownTelemetryNoiseFromUrl(payload.url);
          if (telemetryNoise) {
            telemetryNoiseByPage.set(payload.page_url, telemetryNoise);
            addNoiseEvent(
              report,
              noiseDedupe,
              makeNoiseEvent(
                "network",
                payload.page_url,
                `${payload.method} ${payload.url} failed`,
                telemetryNoise.source,
                telemetryNoise.reason,
                payload,
              ),
            );
            await appendJsonl(networkLogPath, { kind: "requestfailed", ...payload, noise: telemetryNoise });
            return;
          }
          report.network_summary.failed_requests += 1;
          addFinding(report, findingDedupe, makeFinding("error", "failed-request", payload.page_url, null, `${payload.method} ${payload.url} failed`, null, payload));
          await appendJsonl(networkLogPath, { kind: "requestfailed", ...payload });
        });

        page.on("response", async (response) => {
          const status = response.status();
          if (status >= 400 && status < 600) {
            const payload = {
              page_url: page.url() || next.url,
              url: response.url(),
              status,
            };
            const telemetryNoise = classifyKnownTelemetryNoiseFromUrl(payload.url);
            if (telemetryNoise) {
              telemetryNoiseByPage.set(payload.page_url, telemetryNoise);
              addNoiseEvent(
                report,
                noiseDedupe,
                makeNoiseEvent(
                  "network",
                  payload.page_url,
                  `${status} for ${payload.url}`,
                  telemetryNoise.source,
                  telemetryNoise.reason,
                  payload,
                ),
              );
              await appendJsonl(networkLogPath, { kind: "response", ...payload, noise: telemetryNoise });
              return;
            }
            if (status < 500) {
              report.network_summary.status_4xx += 1;
            } else {
              report.network_summary.status_5xx += 1;
            }
            const type = status < 500 ? "http-4xx" : "http-5xx";
            const severity = status < 500 ? "warning" : "error";
            addFinding(report, findingDedupe, makeFinding(severity, type, payload.page_url, null, `${status} for ${payload.url}`, null, payload));
            await appendJsonl(networkLogPath, { kind: "response", ...payload });
          }
        });

        try {
          await page.goto(applyCacheMode(next.url, cacheMode), { waitUntil });
        } catch (error) {
          report.run_status = report.visited_pages.length === 0 ? "failed" : "partial";
          addFinding(report, findingDedupe, makeFinding("error", "navigation-failed", next.url, null, error.message));
          await page.close();
          if (report.visited_pages.length === 0) {
            run.run_status = "failed";
            run.exit_code = EXIT_CODES.NAVIGATION_FAILED;
            run.finished_at = new Date().toISOString();
            await writeJson(path.join(reportDir, "run.json"), run);
            process.exitCode = EXIT_CODES.NAVIGATION_FAILED;
            throw error;
          }
          continue;
        }

        const pageTitle = await page.title();
        report.visited_pages.push({
          url: page.url(),
          title: pageTitle,
          depth: next.depth,
          source: next.source,
        });

        pageIndex += 1;
        for (const viewportKey of viewportKeys) {
          const screenshotName = `${String(pageIndex).padStart(2, "0")}_${slugFromUrl(page.url())}_${viewportKey}.png`;
          const viewportArtifact = await captureViewportArtifact(
            browser,
            page.url(),
            viewports,
            viewportKey,
            waitUntil,
            timeout,
            screenshotsDir,
            screenshotName,
            screenshotMode,
            scrollPrime,
            interactionProfile,
            cacheMode,
          );
          const screenshotPath = viewportArtifact.screenshotPath;
          const layout = viewportArtifact.layout;
          report.viewport_results.push({
            page_url: page.url(),
            viewport: viewportKey,
            width: viewportArtifact.width,
            height: viewportArtifact.height,
            screenshot_path: screenshotPath,
            state_screenshots: viewportArtifact.stateScreenshots,
            horizontal_overflow: layout.horizontalOverflow,
            oversized_elements_count: layout.oversized.length,
            broken_images_count: layout.brokenImages.length,
            overlay_obstruction_count: layout.overlays.length,
          });

          if (mode === "audit") {
            if (layout.horizontalOverflow) {
              addFinding(report, findingDedupe, makeFinding("warning", "horizontal-overflow", page.url(), viewportKey, "Document scroll width exceeds viewport width"));
            }
            for (const item of layout.oversized) {
              addFinding(report, findingDedupe, makeFinding("warning", "oversized-element", page.url(), viewportKey, `Element overflows viewport by ${Math.round(item.overflow)}px`, item.selector, item));
            }
            for (const item of layout.brokenImages) {
              addFinding(report, findingDedupe, makeFinding("warning", "broken-image", page.url(), viewportKey, `Broken image: ${item.src}`, "img", item));
            }
            for (const item of layout.overlays) {
              addFinding(report, findingDedupe, makeFinding("warning", "overlay-obstruction", page.url(), viewportKey, "Large fixed or sticky overlay blocks viewport center", item.selector, item));
            }
          }
        }

        if (mode !== "capture" && next.depth < maxDepth && report.visited_pages.length < maxPages) {
          if (interactionProfile === "common") {
            await openCommonNavigation(page);
          }
          const candidates = await collectCandidateLinks(
            page,
            targetOrigin,
            includePatterns,
            excludePatterns,
          );
          for (const candidate of candidates) {
            if (!seen.has(candidate.url)) {
              queue.push({ url: candidate.url, depth: next.depth + 1, source: candidate.source });
            }
          }
        }

        await page.close();
        if (mode === "capture") {
          break;
        }
      } finally {
        await crawlContext.close();
      }
    }
  } catch (error) {
    if (process.exitCode == null) {
      process.exitCode = EXIT_CODES.INTERNAL_ERROR;
      run.run_status = "failed";
      run.exit_code = EXIT_CODES.INTERNAL_ERROR;
    }
    report.run_status = run.run_status === "failed" ? "failed" : "partial";
    addFinding(report, findingDedupe, makeFinding("error", "internal-error", targetUrl, null, error.message));
  } finally {
    if (browser) {
      await browser.close();
    }
  }

  const finishedAt = new Date().toISOString();
  report.finished_at = finishedAt;
  run.finished_at = finishedAt;
  if (report.run_status === "success" && process.exitCode == null) {
    run.run_status = "success";
    run.exit_code = EXIT_CODES.SUCCESS;
  } else if (report.run_status === "partial" && process.exitCode == null) {
    run.run_status = "partial";
    run.exit_code = EXIT_CODES.SUCCESS;
  }

  await writeJson(path.join(reportDir, "run.json"), run);
  await writeJson(path.join(reportDir, "report.json"), report);
  if (format === "md" || format === "both") {
    await fs.writeFile(path.join(reportDir, "summary.md"), renderSummary(report), "utf8");
  }
  if (format === "html" || format === "both") {
    await fs.writeFile(path.join(reportDir, "report.html"), renderHtmlReport(report), "utf8");
  }

  if (process.exitCode == null) {
    process.exitCode = EXIT_CODES.SUCCESS;
  }
}

main().catch((error) => {
  console.error(error.message);
  if (process.exitCode == null) {
    process.exitCode = EXIT_CODES.INTERNAL_ERROR;
  }
});
