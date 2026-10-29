---
name: workday-listing-scrape
description: How to fetch Workday (myworkdayjobs.com) job listings and why WebFetch and the attached Brave/Edge session can both give false negatives/blocks. See also [[attached-session-csp-blocking]] for the general pattern across sites.
metadata:
  type: feedback
---

Workday CXS-tenant job pages (e.g. `*.wd503.myworkdayjobs.com/en-US/careers/job/...`) are a pure client-side SPA bootstrapped by an inline `<script>`. Consequences:

- **WebFetch always returns empty** — it doesn't execute JS, so there is nothing to extract. Don't bother retrying WebFetch on Workday job URLs; go straight to a browser.
- **The operator's attached Brave session (CDP :9222, see [[brave-cdp-9222-attach]]) can fail silently on Workday**: Brave's built-in shields blocked the page's inline bootstrap script (console showed CSP `script-src-elem 'none'` violations escalating from report-only INFO to actually-blocked ERROR) AND blocked the underlying `/wday/cxs/<tenant>/careers/job/...` XHR/fetch entirely with `net::ERR_BLOCKED_BY_CLIENT`. Result: `document.body.innerText` reads 0 length, looks like the page never loaded, easy to misdiagnose as a network/nav problem.
- **Fix**: open a second, unattached, extension-free Playwright browser instance (`playwright-cli -s=<name> open` — no `--cdp`) and `goto` the same URL there. No shields/adblock, the SPA renders normally and `document.body.innerText` returns real content within ~3s.
- Hitting the `/wday/cxs/<tenant>/<site>/job/<slug>` API directly by navigating to it (rather than letting the SPA call it) returns a 403 `{"errorCode":"S22", "message":"permission denied"}` — that endpoint needs to be called by the page's own JS with its normal headers, not visited directly. Don't try to shortcut via that URL.
- **BUT: same-origin `fetch()` from within the loaded SPA page works cleanly (unattached session).** After `goto` the tenant landing page (e.g. `https://<tenant>.wd12.myworkdayjobs.com/en-US/<site>`), run in `eval`:
  - Search: `fetch('/wday/cxs/<tenant>/<site>/jobs',{method:'POST',headers:{'Content-Type':'application/json','Accept':'application/json'},body:JSON.stringify({appliedFacets:{},limit:20,offset:0,searchText:'<title>'})})` → JSON `{total, jobPostings:[{title, externalPath, locationsText, postedOn, bulletFields:[reqId]}]}`.
  - Detail: `fetch('/wday/cxs/<tenant>/<site>/job/<externalPath-tail>',{headers:{'Accept':'application/json'}})` → JSON `jobPostingInfo` with `jobDescription` (full HTML), `location`, `postedOn` ("Posted N Days Ago"), `startDate`, `jobReqId`, `externalUrl`, and liveness flags **`canApply` / `posted`** (both true = OPEN). This is the cleanest verbatim-JD + liveness read for Workday employers; no CSS-clamp, no SPA render wait.
- Pax8 uses Workday (`pax8inc.wd12.myworkdayjobs.com`, site `Pax8Careers`), NOT Greenhouse — `job-boards.greenhouse.io/pax8` 404s. Pax8's `pax8.com/en-us/careers/` "search jobs" links point at the Workday board.
- Workday's true "not found / closed" state renders as body text `"The page you are looking for doesn't exist."` on an otherwise normal Careers-branded page (not an HTTP error) — that's the real "closed" signal, distinct from the blocked-by-client empty-body false negative above.
