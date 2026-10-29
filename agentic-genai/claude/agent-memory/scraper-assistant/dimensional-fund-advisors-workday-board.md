---
name: dimensional-fund-advisors-workday-board
description: Dimensional Fund Advisors (DFA) careers = Workday wd5 tenant `dimensional` site `DFA_Careers`; CXS API for liveness/JD/reqID
metadata:
  type: reference
---

Dimensional Fund Advisors ("Dimensional", investment manager, Austin TX) careers board:

- ATS: Workday. Board URL `https://dimensional.wd5.myworkdayjobs.com/DFA_Careers` (also `/en-US/DFA_Careers`).
- Public careers page `us.dimensional.com/careers` 301-redirects to `www.dimensional.com/us-en/careers` (WebFetch gets 404 on the localized path; use the Workday board directly).
- CXS list: `POST /wday/cxs/dimensional/DFA_Careers/jobs` body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"software engineer"}`.
- CXS detail: `GET /wday/cxs/dimensional/DFA_Careers{externalPath}` with `Accept: application/json`; JD in `jobPostingInfo.jobDescription` (HTML, has `&#39;` entities), `jobReqId` like `2026-8866`, `startDate` = posted date, `location`+`additionalLocations`, `payRange` usually absent (DFA rarely posts salary).
- Req ID convention: `YYYY-NNNN` (year-prefixed). Engineering roles sit under "Investment Engineering" (Portfolio Engineering / Data Solutions / Analytics Platforms teams) and "Technology Dept / Data Distribution".
- "Full Stack Software Engineer" (the Indeed/LinkedIn title) is a syndication label; on the board the equivalent is "Senior Associate, Investment Engineering (Portfolio Engineering)" — JD literally says "This is a full stack position."

**CXS throttling:** after ~4-6 rapid POST/GET calls the endpoint starts returning `HTTP 400` `{"errorCode":"HTTP_400"}` (not 429) or empty `{"jobPostings":[]}`. Space calls out (30-60s) or batch fewer per eval. Not a block on the query itself.
