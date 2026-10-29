---
name: symetra-eightfold-ats-board
description: Symetra (insurance, Bellevue WA) careers ATS is Eightfold at symetra.eightfold.ai; use the public apply/v2 JSON API for liveness + full JD
metadata:
  type: reference
---

Symetra Financial Corporation careers run on Eightfold, not Workday.

- Careers portal: https://symetra.eightfold.ai/careers (LinkedIn "Apply" routes here via linkedin.com/safety/go redirect)
- Job detail SPA: `symetra.eightfold.ai/careers/job/<eightfoldId>` — renders blank body in the operator's attached CSP-blocked session, so use the API instead.
- Per-job JSON: `https://symetra.eightfold.ai/api/apply/v2/jobs/<eightfoldId>?domain=symetra.com` — returns full record with `job_description` (HTML), `display_job_id` (short req # like 9307), `ats_job_id`, `t_create`/`t_update` epoch secs, `isPrivate`, `canonicalPositionUrl`. A valid non-404 record with `isPrivate:false` = live.
- Listing search: `https://symetra.eightfold.ai/api/apply/v2/jobs?domain=symetra.com&query=<terms>&num=50&start=0&sort_by=relevance` — `positions[]` each has `display_job_id`, `name`, `location`, `t_create`. If a req's short id shows here it is still open.
- All eng roles list `location: "USA"` / `locations: ["USA"]` (remote-first company with WA HQ); no city granularity in API.

Related: [[attached-session-csp-blocking]], [[linkedin-guest-jobposting-api]]
