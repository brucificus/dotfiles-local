---
name: workiva-workday-wd503-careers
description: Workiva (compliance/reporting SaaS, remote-first, HQ Ames IA) careers board is Workday tenant `workiva` site `careers` on wd503
metadata:
  type: reference
---

Workiva careers ATS: `workiva.wd503.myworkdayjobs.com/careers`.

- CXS list: `POST https://workiva.wd503.myworkdayjobs.com/wday/cxs/workiva/careers/jobs` with `{appliedFacets:{}, limit, offset, searchText}` -> JSON `{total, jobPostings:[{title, externalPath, locationsText, postedOn, bulletFields:[REQID]}]}`. Req IDs look like `R11993`.
- CXS detail: `GET .../wday/cxs/workiva/careers/job/<externalPath>` -> `{jobPostingInfo:{title, jobReqId, location, startDate, postedOn, canApply, jobDescription(HTML)}}`. `canApply:true` + HTTP 200 = live; expect 404 for a pulled req.
- These CXS fetch calls succeed even through the operator's attached Edge session (same-origin XHR is fine); only the Workday SPA bootstrap is CSP-blocked (job page renders blank body). No need for an unattached browser for liveness/JD — just hit the API via `page.evaluate(fetch)`.
- Remote US roles show `location:"USA - Remote"`. See [[workday-cxs-jobs-api]] for the general pattern and [[attached-session-csp-blocking]].
