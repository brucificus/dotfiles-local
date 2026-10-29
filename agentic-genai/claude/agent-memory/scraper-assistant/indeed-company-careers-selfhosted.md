---
name: indeed-company-careers-selfhosted
description: Indeed (the company) careers ATS = self-hosted on indeed.com, NOT SmartRecruiters anymore; how to get jobkey + liveness for an Indeed internal req
metadata:
  type: reference
---

Checking liveness of a requisition at **Indeed the company** (employer, not the job board):

- Indeed has left SmartRecruiters. `careers.smartrecruiters.com/Indeed` renders "No job postings are currently available" and `api.smartrecruiters.com/v1/companies/Indeed/postings` returns `totalFound:0`. Do not treat that as the source of truth.
- Indeed self-hosts its careers on the Indeed job board itself. `indeed.com/careers` location picker just routes to **`indeed.com/cmp/Indeed/jobs`**. Individual postings are ordinary `indeed.com/viewjob?jk=<key>` pages.
- Indeed's internal req number shows in the viewjob body as plain text **"Reference ID: 47198"** (no jobkey relationship). Comp shows as "Tier N - United States of America ... USD per year".

Workflow that works from the operator's attached (CSP-injecting) Edge/Brave:
1. `goto https://www.indeed.com/cmp/Indeed/jobs` — the results LIST is server-rendered and fine. The detail side-panel is NOT: it needs `cmp/-/s/assets/*/jobs-aurora.js` which the attached browser's extension CSP blocks ("Loading job details" forever).
2. Instead of clicking cards, read `[...document.querySelectorAll('[data-jk]')]` — every list card carries its jobkey as `data-jk`. Map jk->title by reading each card's `closest('li').innerText`.
3. `goto https://www.indeed.com/viewjob?jk=<key>` directly — server-rendered, loads fine in the attached browser. Body text has the full JD + "Reference ID". `document.documentElement.outerHTML` embeds `"isJobExpired":false`, `"postedToday":false`, `hiringInsightsModel.age` ("30+ days ago"), and `datePosted` ISO timestamp. `applicantInsightsModel` is usually null (no applicant count).
4. A headless/unattached `playwright-cli open` session hits Indeed's "Blocked - Indeed.com" bot wall — no fallback there. Use the attached browser.

Junk artifact: `data-jk="fedcba9876543210"` with empty text is Indeed's template placeholder card, skip it (cf. the DataAnnotation `456789abcdef0123` artifact).

Indeed does NOT syndicate its own reqs to LinkedIn — LinkedIn company id for Indeed is **36229** (`linkedin.com/company/indeed-com`), and `f_C=36229` job search returns "No matching jobs found" even for live reqs. Absence on LinkedIn is not evidence of closure for this employer.
