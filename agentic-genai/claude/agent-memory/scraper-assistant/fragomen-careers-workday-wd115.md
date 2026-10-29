---
name: fragomen-careers-workday-wd115
description: Fragomen (immigration law firm) careers ATS is Workday wd115 tenant `fragomen` site `FragomenCareers`; old iCIMS subdomain is dead
metadata:
  type: reference
---

Fragomen's live careers ATS is **Workday**, tenant `fragomen`, host `fragomen.wd115.myworkdayjobs.com`, site `FragomenCareers`.

- The old **`careers-fragomen.icims.com` iCIMS subdomain is dead** — returns "Site Not Found / gone: dc409". Do not treat Fragomen as iCIMS anymore.
- CXS jobs search works unauthenticated: `POST https://fragomen.wd115.myworkdayjobs.com/wday/cxs/fragomen/FragomenCareers/jobs` with body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"..."}` after first doing a GET on `/FragomenCareers` in the same browser session to set cookies.
- IT job-category facet id: `630879f00d0c01bfdbc7af2b78330ba2` (filter via `appliedFacets:{jobFamilyGroup:[<id>]}`).
- The CXS **detail** endpoint (`/wday/cxs/.../job/<path>`) 403s even with session cookies (both attached and unattached browser). To confirm a single req is dead, GET the SPA job page `https://fragomen.wd115.myworkdayjobs.com/FragomenCareers/job/<path>_REQ-XXXXXX` and wait ~6s — a removed req renders "The page you are looking for doesn't exist."
- WebFetch and the operator's attached CDP session both 403 on any `/wday/cxs/` path — use an unattached `playwright-cli -s=clean open --browser=msedge` session and `page.evaluate(fetch(...))`. See [[workday-cxs-jobs-api]] and [[attached-session-csp-blocking]].
- Fragomen has ~7 IT reqs at any time, mostly security/product/CRM; a C#/.NET/React full-stack app-dev role is rare there. Their "Senior Full Stack Software Developer" (C#/ASP.NET/React/T-SQL, US Corporate Remote) was REQ-026395 — gone from Workday by 2026-08-28 while its LinkedIn promoted post (ID 4420648101) still showed as reposted.
