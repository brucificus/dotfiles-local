---
name: bnsf-careers-phenom-repost
description: BNSF (jobs.bnsf.com) is Phenom ATS; tech roles repost weekly under fresh Job Id, old id 410s / "has been filled"; use JSON-LD script tag for JD+datePosted
metadata:
  type: reference
---

BNSF Railway careers site jobs.bnsf.com is Phenom People ATS. URL form `jobs.bnsf.com/us/en/job/<id>/<slug>`.

- **"bnsf | tech" division reposts the same remote role under a new numeric Job Id roughly every 7 days** (their JD literally says "this job may be removed or filled prior to the closing date, approximately seven (7) days after the posting date"). Example: "Staff Engineering Manager (Remote - US)" was id 94989 (filled Aug 2026), re-posted as id 95431 datePosted 2026-08-27, byte-identical JD.
- **Old/filled id**: page title becomes "We're sorry… the job you are trying to apply for has been filled." (HTTP 200 in browser); WebFetch on the same URL returns **HTTP 410 Gone**. Either = that specific req is dead; search the site for a fresh id.
- **Body innerText does NOT render the JD** in a headless/unattached browser (Phenom lazy-loads it, throws console errors). Instead read `document.querySelector('script[type="application/ld+json"]').textContent` — it carries full description HTML (entity-escaped), `datePosted`, `title`, `identifier.value` (= Job Id). Salary/start-date/Basic Qualifications are all in the description string.
- **Site search**: `jobs.bnsf.com/us/en/search-results?keywords=<x>` is a JS SPA (WebFetch sees template literals, useless). In browser, after load, scrape `a[href*="/job/"]`.
- Parallel LinkedIn guest posting (`/jobs-guest/jobs/api/jobPosting/<id>`) for these BNSF roles stays OPEN / not-updated for weeks after BNSF's own req is filled — LinkedIn status lags, don't trust it as liveness. See [[linkedin-guest-jobposting-api]], [[serco-careers-phenom-site]].
- Indeed viewjob for BNSF roles: browser nav Cloudflare-blocked; WebFetch works but strips the `"expired"` JSON flag, and Indeed keeps stale BNSF postings showing "Apply on company site" with no expiry banner well after the underlying req is filled.
