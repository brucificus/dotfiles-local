---
name: crestron-careers-dayforce-board
description: Crestron Electronics careers = Dayforce candidate portal (tenant crestron); jobs.dayforcehcm.com Next.js board, CSP-blocked in attached session, use clean browser; ?page=N pagination
metadata:
  type: reference
---

Crestron Electronics, Inc. careers.

- `crestron.com/careers` -> 301 `careers.crestron.com` (marketing Radancy-style site) -> "Search Jobs"
  redirects to Dayforce: `jobs.dayforcehcm.com/en-US/crestron/candidateportal`
  (classic host was `globalus231.dayforcehcm.com/CandidatePortal/en-US/crestron/...`; it 301-bounces
  through www.dayforcehcm.com / wkdus261 / etc. — ignore, use the jobs.dayforcehcm.com Next.js board).
- Board is Next.js/AntD. In the operator's ATTACHED Edge/Brave it hangs on "Loading" (CSP block,
  same as other Dayforce boards). Open an UNATTACHED `playwright-cli -s=clean open` session — renders fine.
- curl gets 403 "Forbidden" on both the pages and the search API
  (`/api/geo/crestron/jobposting/search`, POST) even with browser headers; fetch from inside the
  clean page context is ALSO 403. So don't bother with the API — scrape the rendered board.
- Pagination: 25 per page, `?page=2` works as a URL param (`jobs.dayforcehcm.com/crestron/candidateportal?page=2`).
  Or click `li.ant-pagination-item` whose textContent is the page number (plain "Page 2" role-click fails).
- Job detail URL: `/en-US/crestron/candidateportal/jobs/<internal id>` (id ~3200-4600 range, NOT the req #).
  Detail page shows: title, "Req #<NNN>" (the real requisition number, ~700-800s), location list
  (multiple comma addresses = multi-site), "Posted <weekday>, <Month D, YYYY>", full JD, and an
  `<button>Apply</button>` (active button, no href = OPEN; watch for "no longer accepting" text = closed).
  Pay line: "annual pay range for this position ($X - $Y)".
- Locations are physical campuses: Rockleigh NJ (6 Volvo Dr / 22 Link Dr — HQ), Plano TX (7250 Dallas Pkwy),
  Boston MA (529 Main St). Roles listed as onsite/hybrid at those; Indeed syndication may slap a
  "Remote in Flower Mound, TX" tag on the same req that the ATS does NOT carry.
- Whole board is company-wide and small (~41 postings total across all functions as of 2026-08-30).

Snapshot 2026-08-30 — .NET/software eng roles open: "Lead Software Engineer" Req #769 (job 4200,
Plano TX / Rockleigh NJ, posted 2026-04-19, $122.5k-$198k, .NET preferred) — this is the same req as
the EXPIRED Indeed jk=81ae7671d3ddb3ca. Also "Lead Android Software Engineer" Req #795 (Android/Kotlin,
not .NET), "Senior Software Engineer - Audio & Video Streaming" Req #729 (C++, $107.5k-$173.5k),
3x "Co-Op 2026 Software Engineering" interns. Plus ~7 firmware eng reqs (C/C++ embedded).
