---
name: workday-cxs-jobs-api
description: Workday CXS JSON API (/wday/cxs/<tenant>/<site>/jobs POST + /job/<path> GET) for employer-side job liveness without rendering the SPA
metadata:
  type: reference
---

Workday careers sites expose an unofficial JSON API under `/wday/cxs/<tenant>/<site>/`:

- Search: `POST /wday/cxs/<tenant>/<site>/jobs` with body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"<terms>"}` -> `{total, jobPostings:[{title, locationsText, externalPath, postedOn}], userAuthenticated}`. `total:0` + empty array = no such req live.
- Detail: `GET /wday/cxs/<tenant>/<site>/job/<externalPath-minus-leading-/job>` -> full JD JSON. A removed req 404s; the human page shows "The page you are looking for doesn't exist."
- Example tenant/site: Taylor Corp = `taylor.wd1.myworkdayjobs.com` tenant `taylor` site `External`.

**Why:** WebFetch 403s on all `/wday/cxs/` endpoints, and the operator's attached Edge/Brave session also gets `403 permission denied` (errorCode S22) on them plus an empty-body SPA — see [[attached-session-csp-blocking]] and [[workday-listing-scrape]].

**How to apply:** For a Workday employer-liveness check, `playwright-cli -s=fresh open <site root>` in an unattached extension-free browser, then run the fetch inside `page.evaluate(async () => { ... })` (same-origin). Note `run-code` bodies run in Node context unless you explicitly wrap in `page.evaluate` — a bare `fetch` there throws `fetch is not defined`.
