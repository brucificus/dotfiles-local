---
name: empyrean-dayforce-board
description: Empyrean Benefit Solutions careers = Dayforce candidate portal (empyrean); Jobvite board is dead legacy
metadata:
  type: reference
---

Empyrean (a.k.a. Empyrean Benefit Solutions), benefits admin / Health & Welfare SaaS, HQ Houston TX.

Live ATS: `https://jobs.dayforcehcm.com/en-US/empyrean/CANDIDATEPORTAL`
- Reached via goempyrean.com/company/careers "open positions" link.
- CSP-blocked in attached Edge/Brave (33 console errors, blank) -> use unattached/clean browser. See [[attached-session-csp-blocking]].
- Job detail URLs: `.../CANDIDATEPORTAL/jobs/<id>` (4-digit, e.g. 1266). JD footer shows `Req# <n>`.
- Keyword filter is `?searchText=<q>` appended to the CANDIDATEPORTAL root (NOT `/jobs?searchText=`, which 404s). searchText matches JD body text, so it returns false positives.
- Small board (~8-9 open reqs as of 2026-08). Pagination shows page count as a bare digit near the bottom.

Dead legacy board: `jobs.jobvite.com/empyrean-benefit-solutions/jobs` -> always "There are currently no open jobs." Ignore it.

LinkedIn company: `linkedin.com/company/empyrean-benefit-solutions`; jobs filter `f_C=334738,15183291`. LinkedIn job list mirrors the Dayforce board. Indeed `cmp/Empyrean-Benefit-Solutions/jobs` also mirrors it (data-jk on that page is a fake template placeholder).

2026-08-30 observation: ZERO software-engineering / platform / DevOps roles open on any channel. Open reqs were all Finance, Client Service, Implementation, Solutions Consultant. The "Senior Platform Engineer" (Enterprise Technology Development Team, Minneapolis/remote, Terraform/AWS, "preferred C# / .NET Core") that circulated on Indeed (jk=2281cac445000760) was EXPIRED (`isJobExpired:true`).
