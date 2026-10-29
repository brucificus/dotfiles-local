---
name: clearcompany-ats-jobs-api
description: ClearCompany ATS liveness — careers-api.clearcompany.com/v1/<siteId> list + /<siteId>/<jobId> detail return JSON with full HTML description, openDate/postedDate, location; find siteId in career-site.js
metadata:
  type: reference
---

Employer careers pages that say "JavaScript is required to load our job listings ... view openings directly on ClearCompany" are on the ClearCompany ATS.

How to get liveness + full JD without rendering JS:
1. On the employer careers page, look at loaded resources for `careers-content.clearcompany.com/js/v1/career-site.js?siteId=<UUID>` — grab the `siteId`.
2. Jobs list: `GET https://careers-api.clearcompany.com/v1/<siteId>` -> `{ "results": [ {id, positionTitle, description(HTML), openDate, postedDate, location, applyLink, brandName, departmentName, officeName}, ... ] }`. A req only appears here while it is open.
3. Job detail: `GET https://careers-api.clearcompany.com/v1/<siteId>/<jobId>`.
4. Internal requisition number is usually only in the description HTML as "Job Number: NNN" / "Job number: NNN" — regex it out; it is NOT a top-level field.
5. Public apply/careers host is `https://<slug>.clearcompany.com/careers/jobs/<jobId>` (applyLink field gives the exact URL).

Endpoints are plain GET, no auth, CORS-open, WebFetch/curl friendly. Confirmed on Ad Hoc LLC (siteId b6cd7f4b-f4c2-30e4-4b6a-0db2527e4e44, public host adhoc.clearcompany.com).
