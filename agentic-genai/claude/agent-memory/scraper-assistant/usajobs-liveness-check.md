---
name: usajobs-liveness-check
description: How to verify USAJOBS federal announcement open/closed status without an API key
metadata:
  type: reference
---

USAJOBS liveness checks:

- Public REST API `data.usajobs.gov/api/search` returns HTTP 401 Unauthorized without an `Authorization-Key` header (email in User-Agent is not enough). Do not rely on it.
- `curl` the announcement page `https://www.usajobs.gov/job/<controlNumber>` (HTTP 200 even when closed). Parse the raw HTML:
  - JSON-LD `JobPosting` block has `"datePosted":"MM/DD/YYYY"` and `"validThrough":"YYYY-MM-DD"`.
  - Inline JS has `"DateDisplay": "Open MM/DD/YYYY to MM/DD/YYYY"` — the authoritative open/close window.
  - Status badge text `Accepting applications` = OPEN. A closed one shows `This job announcement has closed`. (Note: generic help text contains the phrase "once the announcement has closed" — ignore that; look for the badge.)
  - `Announcement number` and `Control number` are adjacent `<dd>` values.
  - Locations: search for `vacancies in the following locations:` ... also `Telework eligible No / Yes`, `Remote job No / Yes`.
- The `usajobs.gov/Search/Results?k=<kw>&a=<agencyCode>&hp=public` page is a client-rendered SPA; `curl` returns an empty shell. Use a clean (unattached) playwright browser, wait ~4s, then scrape `a[href*="/job/"]`. Agency code for Social Security Administration = `SZ00`.
- SSA posts 2210/IT DHA "public notice" pool announcements with very long open windows (e.g. 6 months) and a JD line "vacancies may be filled for up to 6 months after the closing date" — so "posted months ago" does NOT imply closed.
