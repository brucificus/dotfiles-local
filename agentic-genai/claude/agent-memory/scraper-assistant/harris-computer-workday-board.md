---
name: harris-computer-workday-board
description: Harris Computer / Constellation Software VMS holdco careers = single Workday tenant harriscomputer wd3, site named "1"; CXS list+detail API works via curl
metadata:
  type: reference
---

Harris Computer (a.k.a. Harris; VMS holding co under Constellation Software / Volaris; hundreds of business units — MEDHOST, SmartCop, MACC, DataVoice, Harris ERP, Frontline, etc.). Despite using "multiple ATS platforms" reputationally, the corporate careers board that LinkedIn Apply links resolve to is a **single Workday tenant**:

- Base: `https://harriscomputer.wd3.myworkdayjobs.com`
- Tenant: `harriscomputer`, site path: `1` (literally the digit one — unusual; not "External" / "Careers")
- CXS list: `POST /wday/cxs/harriscomputer/1/jobs` body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"<q>"}` — works via curl, no auth, no CSP issue.
- CXS detail: `GET /wday/cxs/harriscomputer/1/job/<externalPath>` where externalPath is the full slug from the list result (e.g. `Remote---Utah/Senior-Mobile-Developer_R0044908`). GET by bare req ID (`/job/R0044908`) 404s — must use full path.
- Req IDs: `R00#####`. Detail JSON `jobPostingInfo`: `title`, `location` (primary), `additionalLocations` (array; US-remote roles list ~30-50 state names + "Remote"), `startDate`, `endDate` (null = still open), `postedOn` ("Posted 30+ Days Ago" etc.), `jobDescription` (HTML; salary line "Salary range: $X - $Y USD per year" is inline in the description when present, often absent).
- Board is global: ~225 total openings across US/Canada/India/UK/Germany. Each business unit posts its own reqs here; the division name is in the first line of the JD ("<Division>, a division of Harris; is seeking...").
- LinkedIn job alerts scoped to a specific city (e.g. Appomattox VA) can surface a fully Remote-US Harris role because that state is one entry in `additionalLocations`. Verify true location via the CXS detail, not the LinkedIn card.
