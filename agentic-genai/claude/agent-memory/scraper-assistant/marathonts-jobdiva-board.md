---
name: marathonts-jobdiva-board
description: Marathon TS careers ATS is JobDiva; how to reach the job list and search it for liveness checks
metadata:
  type: reference
---

Marathon TS (VA staffing firm) hosts its careers on **JobDiva**, not a small ATS like BambooHR/Lever.

- Entry: marathonts.com nav "Careers" / "Explore Job Openings" -> `https://www1.jobdiva.com/candidates/myjobs/searchjobsdone.jsp?a=<token>&compid=-1` which redirects to `https://www1.jobdiva.com/portal/?a=<token>&compid=0#/`
- Token as of 2026-08: `j7jdnwgck4wulo816y7l865pzq556q05f5cqdk65b0o0dpy0m5p196w9a9ln1g3w`
- React SPA. WebFetch returns only the EEO boilerplate (no jobs). Attached operator browser (CDP 9222) is CSP-blocked (jquery/bootstrap/pako all `FAILED ... csp`) so the app never renders -> open an **unattached** `-s=clean` msedge browser instead. See [[attached-session-csp-blocking]].
- Search box: `getByPlaceholder('Search job title or keyword...')`, press Enter. Keyword match is loose/relevance-ranked (job count can rise, not fall) but the best match lands at result #1-2.
- Each card shows: title, snippet, Details button, date (MM/DD/YYYY = posted date), req number `26-00###`, location (N/A = remote).
- Detail view URL: `#/jobs/<numericId>?jobtitle=<enc>`; shows "#<reqno>", location, "Apply Now" button, full JD. No salary band on JobDiva (LinkedIn adds its own).
- Marathon reposts the same TTB (Tax & Trade Bureau) full-stack role under sibling reqs: 26-00159 "Senior Angular Full Stack Developer" (Mar 2026), 26-00228 "Full Stack Developer" (Apr 2026), 26-00479 "Senior Java Focused Full Stack Developer" (Aug 2026) = the one that shows on LinkedIn as "Senior Full Stack Developer - Java".
