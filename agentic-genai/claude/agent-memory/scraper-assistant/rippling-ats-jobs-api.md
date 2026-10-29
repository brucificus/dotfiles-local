---
name: rippling-ats-jobs-api
description: Rippling ATS (ats.rippling.com/<slug>/jobs) is a JS SPA; use the JSON API to check open reqs / employer-listing liveness
metadata:
  type: reference
---

When an employer's careers page routes to `ats.rippling.com/<company-slug>/jobs` (a Next.js SPA), don't rely on WebFetch rendering the board.

Hit the JSON API directly, no auth:
`https://api.rippling.com/platform/api/ats/v1/board/<company-slug>/jobs`

- Returns a JSON array of open postings, or `[]` when the company has zero open roles.
- Bad slug returns `{"error_code":"RESOURCE_NOT_FOUND","message":"Job Board not found"}` — try the `-llc` / legal-entity variant of the slug (e.g. `crunchafi-llc`, not `crunchafi`).
- `[]` is strong evidence a specific requisition has been pulled/filled on the employer side, even while the LinkedIn guest page still shows it as open (LinkedIn guest/`jobs-guest` pages cache "open" state for weeks and often lack a "No longer accepting applications" banner). Report LinkedIn-open + employer-ATS-empty as CLOSED-on-employer-side with that nuance.

There is also a white-label host `<slug>.rippling-ats.com` (e.g. `rugiet-health.rippling-ats.com`) — a server-rendered board that DOES show job text and per-job detail pages (`/job/<numericId>/<slug>`) via plain goto, no SPA problem, no auth. Job detail pages carry the full JD but usually NO visible posted/updated date. The `api.rippling.com/platform/api/ats/v1/board/<slug>/jobs` endpoint does NOT necessarily share the same slug as the `rippling-ats.com` subdomain (rugiet-health returned RESOURCE_NOT_FOUND on every slug variant tried) — when the white-label board renders fine, just read it directly and skip the API.

Related: [[linkedin-guest-jobposting-api]], [[webfetch-vs-browser-for-listings]]
