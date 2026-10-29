---
name: attached-session-csp-blocking
description: A browser extension in the operator's attached Edge/Brave profile injects a restrictive CSP that silently blocks first-party JS bundles (LinkedIn, Workday, likely others) — page looks "stuck loading" with only skeletons/nav, not an auth or network issue.
metadata:
  type: feedback
---

Confirmed on LinkedIn (2026-08-05) in addition to the earlier Workday case ([[workday-listing-scrape]]): when attached to the operator's visible browser via `attach --cdp=msedge` (or Brave, see [[brave-cdp-9222-attach]]), an installed extension (seen as `chrome-extension://jjhefcfhmnkfeepcpnilbbkaadhngkbi/injection/index.js`) injects a page CSP with `script-src-elem 'none'`. This silently blocks the site's own first-party script bundles (e.g. `static.licdn.com/aero-v1/sc/h/assets/*.js`) from loading.

Symptoms:
- Page title and top-level header fields (job title, company, salary range, "No longer accepting applications" banner) render fine because they're server-rendered.
- The body/description content stays as gray skeleton placeholders forever — reload doesn't fix it, waiting doesn't fix it.
- `document.body.innerText` comes back short (~1300 chars) with only nav/footer boilerplate, no page content.
- `console` shows dozens of `[ERROR] ... violates the following Content Security Policy directive: "script-src-elem 'none'"` for the site's own CDN scripts.

This is NOT a login wall, NOT a closed/removed listing, and NOT a network problem — don't misdiagnose it as any of those. Check console errors for CSP violations before concluding the listing itself is broken.

**Fix**: open a second, unattached, extension-free Playwright browser (`playwright-cli -s=<name> open <url>` — no `--cdp`). Content renders normally within seconds. Use the attached/authenticated session only to confirm status banners (open/closed) that are server-rendered and visible even when the body is stuck; use the clean unattached browser to pull full body/description text.
