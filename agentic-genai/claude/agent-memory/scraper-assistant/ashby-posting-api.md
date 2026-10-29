---
name: ashby-posting-api
description: Ashby ATS public job-board API returns full JD + publishedAt + isListed + comp tiers as clean JSON; use raw JSON not WebFetch summary
metadata:
  type: reference
---

For employers on Ashby (job pages at `jobs.ashbyhq.com/<org-slug>/<uuid>`), the public board API is:
`https://api.ashbyhq.com/posting-api/job-board/<org-slug>?includeCompensation=true`

Returns JSON with a `jobs[]` array. Per posting: `id`, `title`, `location` + `secondaryLocations[]`, `publishedAt` (authoritative posted date), `isListed` (employer-side liveness), `jobUrl`, `applyUrl`, `descriptionHtml`, `descriptionPlain` (complete verbatim JD, no truncation), and `compensation.compensationTiers[]` with real min/max salary per tier.

- No auth, no CSP issues. Works via unattached browser `page.evaluate(JSON.parse(document.body.innerText))` or WebFetch. An ATTACHED (operator-browser) tab CAN load this JSON endpoint fine even though it CSP-blocks the rendered `jobs.ashbyhq.com/<slug>` SPA — hit the API URL directly in the tab and `JSON.parse(document.body.innerText)`.
- WARNING: WebFetch's small-model summary of this endpoint HALLUCINATED the salary numbers (gave $228-264K when JSON said $205-225K). Always pull and parse the raw JSON for exact figures.
- WARNING (2026-08-28, Vanta): WebFetch also TRUNCATES the feed badly — reported "Total Jobs: 7" and "Senior II Fullstack SWE, GRC = NOT FOUND" when the raw JSON actually had 109 jobs including that exact title (isListed:true). Do NOT trust WebFetch for "is title X in the feed" or job counts on a large board — a WebFetch "not found" is a false negative. Always parse raw JSON (browser tab or curl) for liveness/enumeration; only use WebFetch here as a last resort.
- Large boards repost the same role under multiple Ashby ids: Vanta had two "Senior Fullstack Software Engineer, GRC" entries (one with comp tiers, one with empty `compensationTiers:[]`), both isListed:true. Match on title + comp band, and note the newer publishedAt copy may have no comp populated.
- Slug guessing: company "Check" (checkhq.com) -> slug is `check-technologies`. Their careers page at checkhq.com/company/open-positions renders the Ashby list client-side (each row links to the ashbyhq.com posting URL).
- The individual `jobs.ashbyhq.com/...` page shows a "Deadline to Apply" date that the board API does not include — worth capturing from the rendered page for liveness.
- Check (checkhq.com) confirmed on Ashby (was NOT on Greenhouse — `boards.greenhouse.io/check` 404s). See [[attached-session-csp-blocking]] — checkhq.com careers page is also CSP-blocked in the operator's attached browser, needs unattached browser.
