---
name: kobie-lever-board
description: Kobie Marketing (loyalty-marketing) careers ATS is Lever, slug `kobie`, embedded via andreasmb lever-jobs-embed on kobie.com/jobs/
metadata:
  type: reference
---

Kobie Marketing (loyalty-marketing solutions, HQ St. Petersburg FL) careers:
kobie.com → Careers (kobie.com/culture/) → "Join Our Team" → kobie.com/jobs/
which renders an empty `<div id="lever-jobs-container">` filled by
`https://andreasmb.github.io/lever-jobs-embed/index.js` with
`leverJobsOptions = {accountName: 'kobie'}`.

ATS = **Lever**, slug **kobie**.
- List: `https://api.lever.co/v0/postings/kobie?mode=json` (WebFetch truncates this
  badly — it dropped ~20 of 25 postings; fetch raw JSON via browser eval instead).
- Detail: `https://api.lever.co/v0/postings/kobie/<id>?mode=json` — `lists[]` holds
  the requirements/responsibilities HTML; `descriptionPlain` is only the boilerplate
  intro. No `salaryRange` field present (Kobie states no salary).
- Hosted page: `https://jobs.lever.co/kobie/<id>` (CORS-blocks fetch from other
  origins; navigate directly).

"Senior Software Engineer" (remote US, Java/Spring/Angular loyalty platform) =
Lever id `a6035606-b219-4736-9fc1-d4871ba8a84c`, created 2025-10-01, nominal loc
St. Petersburg FL, allLocations includes Minneapolis MN (matches the LinkedIn
repost's nominal location). See [[linkedin-guest-jobposting-api]], [[lever-postings-api]].
