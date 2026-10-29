---
name: crossriver-greenhouse-board
description: Cross River Bank careers ATS is Greenhouse board slug `crossriverbank` (not `crossriver`), embedded at crossriver.com/greenhouse?gh_jid=<id>
metadata:
  type: reference
---

Cross River / Cross River Bank (fintech infra / BaaS, Fort Lee NJ) careers.

- ATS: Greenhouse. Board slug is `crossriverbank` (the obvious `crossriver` 404s).
- Public API works fine, no CSP issues:
  - list: https://boards-api.greenhouse.io/v1/boards/crossriverbank/jobs
  - detail: https://boards-api.greenhouse.io/v1/boards/crossriverbank/jobs/<id>
- Employer site careers.crossriver.com/careers#careers renders the board via a
  JS embed (greenhouse.io/embed/job_board/js?for=crossriverbank). The
  crossriver.com/greenhouse?gh_jid=<id> "See Job Post" page is CSP-blocked /
  non-rendering in the attached Edge session (60+ console errors, only nav chrome
  shows) - use the boards-api JSON instead. The slug string is recoverable from
  that page's HTML (`for=crossriverbank`).
- Detail JSON gives: requisition_id (short, e.g. "1479"), first_published,
  updated_at, location.name, departments, offices, content (double HTML-escaped),
  salary range is inside content text ("Salary Range: $X - $Y").
- LinkedIn Apply button on Cross River postings deep-links to
  crossriver.com/greenhouse?gh_jid=<same id> so gh_jid == Greenhouse job id.
