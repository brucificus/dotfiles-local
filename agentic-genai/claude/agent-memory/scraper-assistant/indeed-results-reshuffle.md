---
name: indeed-results-reshuffle
description: Indeed search results are not stable across page reloads — same URL/start= param returns a different mix of postings each time, breaking retroactive HREF lookups
metadata:
  type: project
---

Indeed's job search results (e.g. `indeed.com/jobs?q=&l=...&start=N`) are NOT deterministic across reloads. Reloading the exact same URL with the same `start=` offset returned a visibly different set of company/title cards on a second load — sponsored/related slots appear to rotate per page-load, not just per pagination offset.

**Why this matters:** if you score/extract a page of results, then later need to go back and pull HREFs (or any other detail) for those same rows by re-navigating to the same URL, you cannot assume the DOM will contain the same postings. Matching by title+company text against a fresh load risks silently attaching the wrong job's link to a previously-delivered row.

**How to apply:** Capture every field you'll need (company, title, pay, location, age, HREF/job key) in a single extraction pass at the time you first visit a page — don't plan to "come back later" for missing fields on Indeed. If a user asks for a field you didn't capture (e.g. HREFs added as an afterthought), tell them up front that backfilling may be incomplete/unsafe due to this reshuffling, and offer to redo a clean single-pass re-scan instead of guessing.

**Indeed HREF/job-key technique:** each job card's title is an `<a data-jk="...">` inside `h3`. The canonical dedicated posting URL is `https://www.indeed.com/viewjob?jk=<jk>` (cleaner than the tracking-laden `/rc/clk?jk=...&bb=...` href actually present in the DOM). Bulk-extract via:
`document.querySelectorAll('li')` filtered to `li.querySelector('h3 a[data-jk]')`, mapping to `{jk, title, company}` (company via `li.querySelector('[data-testid="company-name"]')`, which is sometimes blank for some card layouts/sponsored slots).

**Decoy job keys:** watch for `jk` values that are an obviously sequential/placeholder hex pattern (e.g. `456789abcdef0123`, `123456789abcdef0`, `789abcdef0123456`) appearing as a duplicate of a real card's title+company. These look like Indeed-injected decoy values on duplicate/ad slots, not real job keys — prefer the first non-sequential-looking jk when a title+company pair appears twice.

Related: [[edge-attach-remote-debugging]]
