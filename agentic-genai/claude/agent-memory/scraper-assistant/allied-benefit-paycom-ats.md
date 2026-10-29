---
name: allied-benefit-paycom-ats
description: Allied Benefit Systems (health TPA) live careers ATS is Paycom, not the stale Workable board; how to enumerate its jobs
metadata:
  type: reference
---

Allied Benefit Systems, LLC (Chicago health-insurance TPA, remote-friendly) recruiting:

- **Live ATS = Paycom.** Official careers page portal.alliedbenefit.com/Careers "SEE AVAILABLE JOBS" button links to
  `https://www.paycomonline.net/v4/ats/web.php/jobs?clientkey=518A90CE68B712867516B5A3986512DA` which redirects to
  `.../portal/518A90CE68B712867516B5A3986512DA/career-page`.
- **apply.workable.com/allied-benefit-systems is a DEAD legacy board** — renders "Sorry, no job openings at the moment"; Workable widget/v3 APIs return total:0. Ignore it; search results that call Workable their ATS are stale.
- Job list JSON: `POST https://portal-applicant-tracking.us-cent.paycomonline.net/api/ats/job-posting-previews/search`
  body `{"skip":0,"take":50,"filtersForQuery":{"distanceFrom":0,"workEnvironments":[],"positionTypes":[],"educationLevels":[],"categories":[],"travelTypes":[],"shiftTypes":[],"otherFilters":[],"keywordSearchText":"","location":"","sortOption":""}}`.
  Needs a short-lived `authorization` Bearer JWT the SPA injects (NOT in localStorage/sessionStorage) — an unauthenticated replay returns empty body. Easiest: just paginate the rendered UI (10/page, numbered page buttons) and read `a[href*="/jobs/"]`.
- Job detail URL: `.../portal/518A90CE68B712867516B5A3986512DA/jobs/<jobId>` — SPA, needs a real browser (attached session works here, unlike CSP-blocked Workable/LinkedIn). Shows Salary Range + Position Type + Category + full description; **no posted date shown**. Higher jobId = more recently opened.
- Paycom career-page SPA is blank in the operator's **attached** CDP session (CSP) — use an unattached `--browser=msedge` session. (`--browser=chrome` fails: Chrome not installed on this box.)

Related: [[attached-session-csp-blocking]], [[linkedin-guest-jobposting-api]]
