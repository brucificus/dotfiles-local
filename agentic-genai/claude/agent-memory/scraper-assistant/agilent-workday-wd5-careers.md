---
name: agilent-workday-wd5-careers
description: Agilent Technologies careers ATS is Workday tenant `agilent` on wd5, site `Agilent_Careers`; CXS API gives liveness + req ID
metadata:
  type: reference
---

Agilent Technologies (careers.agilent.com "Search Jobs" links) resolves to Workday:
`agilent.wd5.myworkdayjobs.com` — tenant `agilent`, site `Agilent_Careers`.

- Job detail SPA: `.../en-US/Agilent_Careers/job/<slug>_<reqID>-<n>` renders blank via WebFetch (Workday SPA), same as [[workday-cxs-jobs-api]].
- Liveness/JD via CXS: `GET https://agilent.wd5.myworkdayjobs.com/wday/cxs/agilent/Agilent_Careers/job/<slug>_<reqID>-<n>` returns JSON with title, jobRequisitionId (bare number, e.g. 4036644), location, startDate, timeType; a 404 = pulled.
- careers.agilent.com/global/en/search-results?keywords=... 404s directly (not the real search endpoint); go straight to the Workday CXS list/detail API instead.
- Confirmed 2026-08-30: "DevOps & Platform Engineer (AWS / CI/CD)" / CrossLab Connect, req 4036644, US-CO-Remote, active — also live on LinkedIn 4422117111.
