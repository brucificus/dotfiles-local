---
name: uchealth-careers-radancy-jobvite
description: UCHealth (University of Colorado Health) careers site platform + search param + apply ATS
metadata:
  type: reference
---

UCHealth careers board = **careers.uchealth.org** (jobs.uchealth.org does NOT resolve).

- Front-end / job-search: **Radancy TalentBrew + Talemetry "Careersites"** (scripts under `/pack/talemetry_careersites/`, `talemetry.jobsearch.js`, `sitestats.ttcportals.com`). Foundation/jQuery/Slick theme.
- Underlying apply ATS: **Jobvite** (`apply.app.jobvite.com/assets/app/apply.js`, `direct_apply.js`). "Apply now" opens a Jobvite direct-apply flow.
- Listing search: `https://careers.uchealth.org/search/jobs?q=<keyword>` (the `?keyword=` param does NOT filter; `?q=` does). Category filter path: `/search/<category-slug>/jobs` e.g. `/search/information-technology/jobs`.
- Job detail URL: `careers.uchealth.org/jobs/<numeric-id>-<slug>`; page shows Job ID (5-6 digit req, e.g. 383013), Date Posted (e.g. "Aug 12, 2026"), Department, pay range (annual or hourly).
- SPA renders in the attached authenticated browser fine (no CSP block observed); job cards load async so sleep ~2s after goto.

Tech-role footprint is tiny: as of 2026-08-30 the whole system listed only ~5 technical roles (2 Salesforce, IT Program Director, Systems Analyst Sr, Director Clinical Engineering). Keywords ".net", "asp.net", "web developer", "programmer", "mychart", "patient portal" -> zero. UCHealth reposts C#/.NET "Application Developer - Web" (patient-portal/Epic-integration, remote-in-Colorado, dept "UCHlth Application Web Develop") only intermittently.
