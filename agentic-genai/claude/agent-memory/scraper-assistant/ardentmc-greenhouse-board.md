---
name: ardentmc-greenhouse-board
description: Ardent MC (Ardent Management Consulting, ardentmc.com) federal contractor careers = Greenhouse board slug `ardentmc`
metadata:
  type: reference
---

The GovCon "Ardent" whose Indeed employer page is /cmp/Ardent (mission language: "federal government's most critical national security and defense priorities", veterans/cleared professionals) is **Ardent MC / Ardent Management Consulting**, ardentmc.com.

Careers page ardentmc.com/careers/ embeds Greenhouse via `app.greenhouse.io/embed/job_board/js?for=ardentmc` (WordPress greenhouse-job-board plugin). Body is nearly empty in a browser; use the API instead.

- List: `https://boards-api.greenhouse.io/v1/boards/ardentmc/jobs` (~83 open reqs, heavy GIS/geospatial + cybersecurity)
- Detail: `https://boards-api.greenhouse.io/v1/boards/ardentmc/jobs/<id>` (full JD, updated_at, absolute_url)
- Public board: `https://boards.greenhouse.io/ardentmc/jobs/<id>`

WebFetch works fine on the Greenhouse API (no CSP issues). See [[ashby-posting-api]] / other ATS memories for the general pattern.

"Senior Solutions Architect" (Remote, Java/.NET/AWS/Kubernetes, Public Trust) = GH id **7974269**.
