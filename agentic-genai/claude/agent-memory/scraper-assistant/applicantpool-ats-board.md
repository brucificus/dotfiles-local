---
name: applicantpool-ats-board
description: ApplicantPool/ApplicantPro career sites are Vue SPAs; attached session CSP-blocks them, jobs list renders fine in a clean unattached browser
metadata:
  type: reference
---

ApplicantPool (applicantpool.com) / ApplicantPro career sites are Vue 3 SPAs. Board URL pattern: `https://<subdomain>.applicantpool.com/jobs/`, individual reqs at `/jobs/<numericId>`.

- The job list is client-rendered by a `<job-listings>` web component. Page HTML only carries a `componentData` mount blob (organizationId, domainId), NOT the postings.
- No usable public JSON feed found: `/jobs/?format=json`, `/jobs/rss/`, `/api/jobs` all 404 or return the SPA shell. The bundle chunk (`public-career-site-*.js`) only exposed `/core/api/log-event/`; the real job-search endpoint is in a lazy chunk, not worth chasing.
- Operator's attached Edge (NoScript-style extension, id bgkmgpgeempochogfoddiobpbhdfgkdi) CSP-blocks unpkg Vue + first-party component JS -> board renders as just "View All Current Job Listings" with no postings. Same class of failure as [[attached-session-csp-blocking]].
- Fix: `playwright-cli -s=clean open --browser=msedge <url>`, wait ~5s, `eval document.body.innerText`. Renders the full list ("Number of Jobs: N", titles, location, employment type, pay, "Posted: <date>") and per-row `/jobs/<id>` links.

Confirmed 2026-08-30 on Thomas and Company (subdomain `thomasandcompany`, org 4319, domain 5598).
