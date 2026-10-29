---
name: par-technology-ashby-board
description: PAR Technology Corp (NYSE:PAR, restaurant tech, Brink POS) careers = Ashby board, org slug "PAR Technology" (space, URL-encoded %20)
metadata:
  type: reference
---

PAR Technology Corporation (partech.com / par.com) careers:
- Careers landing: partech.com/careers/ -> "Job Postings" / partech.com/careers-at-par/ (WordPress marketing pages, CSP-noisy but render in attached browser)
- ATS: **Ashby**. Org slug is literally `PAR Technology` with a space -> URL-encode as `PAR%20Technology`.
- Board API (no auth, works in attached tab, `JSON.parse(document.body.innerText)`):
  `https://api.ashbyhq.com/posting-api/job-board/PAR%20Technology?includeCompensation=true`
- Individual posting pages: `https://jobs.ashbyhq.com/PAR%20Technology/<uuid>`
- Talent-community form: `jobs.ashbyhq.com/PAR%20Technology/form/partech-talent-community`
- Postings use UUID ids only (no human req ID exposed in the board API). `isListed` = liveness. `publishedAt` = posted date. Compensation tiers present on many US-remote roles ("$140K – $160K • Offers Bonus" style, matches the Ashby JD-header format seen on Indeed cards).
- Every JD opens with the same boilerplate "For over four decades, PAR Technology Corporation (NYSE: PAR) has been a leader in restaurant technology..." — not useful for keyword matching; scan the body.
- Roles split across US-remote (state-specific "Remote - <State>" secondary locations), Remote Canada / Markham ON, and India (Gurugram / Jaipur). India eng roles: Software Engineer II, Senior Application Engineer, Staff AI Engineer, Engineering Manager, Senior QE Engineer, SRE I.
- 2026-08-30 sweep: NO job on the board mentioned "Brink" at all; no "Senior Software Engineer" C#/.NET Brink-POS role listed. US-remote SWE roles present were NodeJS/Ruby/Data/DevOps, not C#/.NET. So the Brink POS C#/.NET Senior SWE role appears to be an intermittent posting.
