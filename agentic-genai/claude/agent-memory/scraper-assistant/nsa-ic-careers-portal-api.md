---
name: nsa-ic-careers-portal-api
description: apply.intelligencecareers.gov (NSA / IC Candidate Portal) SPA renders empty in attached CSP-blocked browser; use its same-origin JSON API via curl instead
metadata:
  type: reference
---

NSA and the wider Intelligence Community post jobs on `apply.intelligencecareers.gov`
("IC Candidate Portal", an Angular SPA). The LinkedIn company page name
"CNSS - National Security Systems" maps to this employer; real hiring agency is NSA.

**The SPA renders a blank `<body>` in the operator's attached Brave/Edge session**
(same attached-session CSP blocking as [[attached-session-csp-blocking]]). Don't wait
on it. Hit the JSON API directly:

- `GET https://apply.intelligencecareers.gov/job-listings/job-description?jobNumber=<ID>`
  returns the full job record as JSON (fields: jobTitle, location, locationFull,
  jobPayPlan, grade, jobOpenDate, jobCloseDate, postedDate, jobStatus, jobVisible,
  fullDescription, jobRequirements, jobQualificationsExt, jobSkillsInternal,
  jobWorkSchedule (pay/salary range lives here), jobHowToApply, jobDCIPS).
- `GET https://apply.intelligencecareers.gov/job-listings/search?keyword=<kw>` returns
  ~35 most-recent visible listings. The keyword param appears to be ignored server-side
  (same 35 rows regardless), so filter titles client-side. Use it to check whether a
  given title is currently open.

Required header: `-H "X-Requested-With: XMLHttpRequest"` (plus a normal UA and
`Accept: application/json`). Without the XHR header the path returns the SPA HTML shell.

Gotchas:
- NSA reposts the same title on a ~2-week cycle under a NEW jobNumber each time.
  A jobNumber from Google/Indeed/Glassdoor is often a stale earlier iteration whose
  close date has passed. `jobVisible:true` / `jobStatus:"010"` can persist on expired
  records - trust `jobCloseDate` vs today, and cross-check the search list for a
  currently-open row with the same title.
- Web page URL form is `https://apply.intelligencecareers.gov/job-description/<ID>`.
