---
name: usi-insurance-avature-board
description: USI Holdings / USI Insurance Services careers = Avature ATS at jobs.usi.com; fuzzy search, JobDetail?jobId=, closed reqs redirect to /Jobs/Error
metadata:
  type: reference
---

USI Holdings Corporation (USI Insurance Services) careers site = **Avature** ATS.

- Board: `https://jobs.usi.com/` ; all-jobs listing `https://jobs.usi.com/Jobs/OpenPositions?listFilterMode=1&jobRecordsPerPage=20&`
- Keyword search: `https://jobs.usi.com/Jobs/OpenPositions/<URL-encoded query>?listFilterMode=1&jobRecordsPerPage=50&`
- Job detail: `https://jobs.usi.com/Jobs/JobDetail?jobId=<id>` (also slug form `/Jobs/JobDetail/<slug>/<id>`)
- Platform tells: `avacdn.net` assets, title "Careers Marketplace", `jobs.usi.com/portal/46/...`
- **Liveness**: a closed/removed req redirects to `https://jobs.usi.com/Jobs/Error` ("Page not found"). Live listing rows show `Job ID: NNNNN • Posted DD-Mon-YYYY` plus an APPLY button.
- **Search is loose/relevance-ranked, not a filter**: a query with few/no real matches (e.g. ".NET", "C#", "IT", "Technology") still returns a page full of unrelated insurance/benefits/producer roles. Only trust results when the header says "N results" with a small N, or "No jobs found". Exact-ish tech titles ("Architect", "Developer", "React", "Programmer", "Lead Architect") correctly return "No jobs found" when nothing matches.
- Company is ~all insurance brokerage/benefits/sales roles (~755 open Aug 2026). Engineering/software roles are rare and posted centrally on this same board when they exist (e.g. former "Enterprise Software Architect" req 32235, "Software Lead Architect" LinkedIn 4273976848). React/TypeScript + C#/.NET stack for the architecture team.
