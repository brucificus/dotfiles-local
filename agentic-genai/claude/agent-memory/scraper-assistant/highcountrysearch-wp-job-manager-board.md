---
name: highcountrysearch-wp-job-manager-board
description: High Country Search Group (Denver IT staffing agency) own job board = WordPress + WP Job Manager plugin; how to read it and its feed
metadata:
  type: reference
---

High Country Search Group (highcountrysearch.com) — Denver IT/finance staffing agency. Their
LinkedIn company page posts MANY roles and hides the end client; their own board is tiny by
comparison.

**Board platform:** WordPress + "WP Job Manager" plugin.
- Public listing page: `https://highcountrysearch.com/opportunities/` — uses AJAX filters
  (`wp-content/plugins/wp-job-manager/assets/dist/js/ajax-filters.js`). This JS is **CSP-blocked
  in the operator's attached Edge/Brave session** (see [[attached-session-csp-blocking]]) — the
  page renders "Your browser does not support JavaScript" placeholder. Use a **clean unattached
  browser** (`playwright-cli -s=clean open ...`) — renders the card list fine.
- Job detail URL pattern: `https://highcountrysearch.com/job/<slug>/` (slug IS the identifier;
  no req/ref IDs anywhere). Some older posts use `/?post_type=job_listing&p=<id>`.
- Detail page has `<script type="application/ld+json">` with `datePublished` (WebPage node, not
  a JobPosting node) = the posted date. Location + full JD in `document.body.innerText`.
- **Job feed (works, no CSP issue):** `https://highcountrysearch.com/?feed=job_feed` — RSS with
  `<item>` per role: title, link, pubDate, `<job_listing:location>`, `<job_listing:company>`
  (always literally "High Counry Search" [sic] — never the real client). NOTE the
  `/opportunities/?feed=job_feed` variant returns HTTP 403 "Comments are closed"; use the bare
  `/?feed=job_feed`. WebFetch gets 403 on it too (bot block) — fetch it same-origin from inside
  the clean browser: `eval "fetch('https://highcountrysearch.com/?feed=job_feed').then(r=>r.text())..."`.
- Feed omits a few board cards (post-type/visibility quirk) — cross-check feed against the
  rendered `/opportunities/` card list; "Load more listings" button on the board was a no-op
  when the full set already fit.

**2026-08-31 snapshot:** whole board = 6 listings (Sr Tax Accountant, Audit Manager, Business
Systems Analyst JD Edwards, Sr. Platform Engineer X2, Operations Engineer, IT Service Desk Tech).
Only ONE C#/.NET or DevOps/platform role: "Sr. Platform Engineer (X2)" (/job/sr-platform-engineer/,
published 2026-06-13), Denver, hybrid, "$150k-153k base + 10% bonus", Azure/Terraform/C#.NET/Python,
"only candidates local to this area will be considered" — i.e. Denver-local-only, no fully-remote
eng roles. This is the same posting as LinkedIn job 4421221173 "Senior Platform Engineer".
