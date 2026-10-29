---
name: medpace-careers-jibeapply-api
description: Medpace careers site (careers.medpace.com, Jibe/iCIMS front-end) has a clean JSON jobs API usable via curl; SPA is CSP-blocked in attached browser and 403s in clean browser
metadata:
  type: reference
---

Medpace careers portal = `careers.medpace.com`, an Angular "jibeapply" front-end that maps to iCIMS reqs (apply links go to `uscareers-medpace.icims.com` / `coloradocareers-medpace.icims.com` / `international-medpace.icims.com`). The old iCIMS job board `uscareers-medpace.icims.com/jobs/<id>/.../job` still exists but redirects/410s.

**Blocking:** attached operator browser CSP-blocks the SPA JS (body ~364 chars, 120+ console errors). Clean unattached browser gets `403 Forbidden` (Akamai bot rule). See [[attached-session-csp-blocking]].

**What works — plain curl with a browser UA:**
- List/search: `GET https://careers.medpace.com/api/jobs?keywords=<kw>&limit=100` (also `&location=` but that param returned non-iterable once; `keywords=Denver` works as a location proxy). Returns `{totalCount, jobs:[{data:{...}}]}`.
- Each `data` has: `req_id` (same number as `careers.medpace.com/jobs/<req_id>`), `title`, `full_location`/`city`/`state`/`country`, `category`, `apply_url`, `posted_date`, `create_date`, `update_date`, `employment_type`, and full `description` (HTML) INCLUDING the "Compensation: A target salary range of $X - $Y" line.
- Presence of a `req_id` in live API results = that req is OPEN.
- Liveness via WebFetch HTTP status: `careers.medpace.com/jobs/<realid>` = 200; bogus id = 404. (WebFetch body is useless — SPA shell only.)

**Medpace software roles are office-based by location.** The Denver, CO "Software Engineer" (internal IT / internal-systems modernization team; C#, ASP.NET, EF, SQL, Angular, Azure) is req 12116, target salary $70k-$145k. Sibling Denver reqs: 12120 Jr Software Engineer (same stack/pay, 3.5 GPA), 12289 Manager Software Development ($140k-$190k). No US-remote SWE roles — all non-Denver SWE reqs are Cincinnati OH. "#LI-Hybrid" tag appears in JD but role text says "office-based".
