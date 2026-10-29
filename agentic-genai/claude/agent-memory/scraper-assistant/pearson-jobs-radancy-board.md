---
name: pearson-jobs-radancy-board
description: Pearson careers = pearson.jobs (Radancy TalentBrew SPA). JS-rendered so WebFetch returns empty; use clean browser, poll for "Loading..." to clear. Search via ?q= (loose relevance), req IDs numeric but URLs use hex GUIDs.
metadata:
  type: reference
---

Pearson's official careers site is `https://pearson.jobs` — a Radancy/TalentBrew
(DirectEmployers-style) SPA. No usable public JSON API found.

Job detail URL shape: `https://pearson.jobs/<location-slug>/<title-slug>/<32-HEX-GUID>/job/`
- e.g. `pearson.jobs/virtual-usa/senior-software-engineer/B0B64891D3164F64ACD9F5E54468FF3A/job/`
- `virtual-usa` = Remote US, `virtual-ind` = Remote India, `virtual-esp`/`virtual-pol` etc.,
  `virtual-lka` = Sri Lanka, or a real city slug like `hoboken-nj`.
- The hex GUID in the URL is NOT the req number. Real **Req ID is numeric** (e.g. 24716, 24751,
  24929) and appears only in the page header text ("Req ID: 24751") — not searchable well.

Search: `https://pearson.jobs/jobs/?q=<term>&location=<place>`
- WebFetch gets an empty shell (SPA). Must use a clean unattached playwright-cli browser.
- After goto, body shows `Loading...` for a beat — re-eval 2-4 times until
  `!document.body.innerText.includes('Loading...')`, then read
  `document.querySelectorAll('a[href*="/job/"]')` for cards and the `N Jobs` count in body text.
- `?q=` is LOOSE RELEVANCE, not a filter: `q=software engineer` returned "97 Jobs" globally,
  "20 Jobs" with `&location=United+States` (includes QA, managers, architects, data eng).
  `q=<exact req number>` returns 0 — a purged/closed req just vanishes from search.
- Total open roles company-wide (`/jobs/` no query): ~432 (Aug 2026).

**Stale deadline caveat:** every Pearson JD ends "Applications will be accepted through <date>.
This window may be extended depending on business needs." Reqs stay listed with Apply Now
active for MONTHS past that date (saw "through 30th June" and "through 5th August" still live
on 2026-08-31). So the deadline line is NOT a liveness signal — presence on the board +
active "Apply Now" is. Conversely, absence from `?q=` search = closed/removed.

**AI-first eng hiring push (2026):** Pearson ran a family of sibling reqs — "Staff Software
Engineer" and "Senior Software Engineer" — all themed around agentic-AI / AI-assisted dev
workflows, C#/.NET + Python (+ sometimes Node.js) + React, AWS or Azure, Docker/K8s, and
name-dropping tools (Cursor, Claude Code, Devin, Ralph, Builder.io). Same theme, different
req numbers per region/level (24716 Denver/Remote-US 5-8yr .NET+Node+Python; 24751 Remote-India
10yr C#/.NET/Python; 24929 "AgentOps Engineering" Remote-US Senior; 25298 Remote-US Senior
Node+Python). Matching by title alone is unreliable — read the Req ID and JD body.
