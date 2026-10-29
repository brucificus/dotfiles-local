---
name: iherb-workday-wd5-careers
description: iHerb's live ATS is Workday tenant `iherb` on wd5, site `Careers` (not wd1, not Greenhouse); CXS API gives liveness + full JD
metadata:
  type: reference
---

iHerb (iherb.com, e-commerce supplements) job-board liveness:

- Correct Workday board: `https://iherb.wd5.myworkdayjobs.com/en-US/Careers`
  - CXS list: `POST https://iherb.wd5.myworkdayjobs.com/wday/cxs/iherb/Careers/jobs` body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"Catalog"}` -> returns `total` + `jobPostings[]` with `title`, `externalPath`, `locationsText`, `bulletFields` (contains the R-number req id).
  - CXS detail: `GET https://iherb.wd5.myworkdayjobs.com/wday/cxs/iherb/Careers/job<externalPath>` -> `jobPostingInfo` with `startDate` (real post date), `canApply`, `posted`, `remoteType`, full `jobDescription` HTML. WebFetch & curl work here directly, no CSP issue.
- WRONG guesses that waste time: `iherb.wd1.myworkdayjobs.com/.../iHerbCareers` -> HTTP 500 / redirects to Workday maintenance page; wd5 site name is `Careers` not `iHerbCareers`.
- Greenhouse: Google indexes `job-boards.greenhouse.io/iherb/jobs/<id>` links but the board slug `iherb` (and every variant) 404s on both the page and `boards-api.greenhouse.io/v1/boards/iherb/jobs`. Treat Greenhouse as dead/migrated for iHerb; use wd5 Workday.
- `careers.iherb.com` is behind Cloudflare "Just a moment..." challenge; not worth scripting.
- LinkedIn company: iHerb `f_C=437225` (id 437225). The iHerb LinkedIn *company jobs page* itself (`/company/iherb/jobs/`) reliably renders 1-2 "recommended" iHerb roles with title + "Actively reviewing applicants" + "Posted N days ago" and an `originToLandingJobPostings=<id>,<id>` link in card order -- more reliable than the LinkedIn `/jobs/search/` SPA, which in the attached session kept falling back to "Jobs you may be interested in" and ignored `keywords`/`f_C` even after reload.
