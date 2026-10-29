---
name: indeed-company-page-js-cards
description: Indeed company cmp/<Co>/jobs listing cards are JS-driven (href="#"), not real links; clicking often fails to populate a details panel via automation
metadata:
  type: feedback
---

On `indeed.com/cmp/<Company>/jobs`, job title buttons render with `href="#"` and require a click to open an in-page details panel showing full description/pay. In practice the panel did not populate reliably via playwright-cli click+eval (page.body.innerText stayed on generic nav text after click). Don't trust a single click+eval to retrieve the panel content — if it fails, re-snapshot immediately after the click and look for a details region by ref rather than re-running body.innerText once.

Also: page 1 titles can be a poor sample. A company with 278 total postings had only "Java Developer" (not plain "Developer") on page 1, and paginated pages 2-5 (start=20/40/60/80) had zero titles matching a keyword — don't assume absence from page 1 alone generalizes, but also don't assume pagination will surface more matches for a specific one-off role since these company pages seem to aggregate genuinely distinct postings, not near-duplicates.

**Why:** Wasted several calls trying to click into a "Developer"-adjacent card expecting a details panel; got nothing back both times.

**How to apply:** When searching a company's Indeed jobs page for a specific title, prefer corroborating with a direct `q=<Company>&l=<location/Remote>` search (see [[indeed-company-jobs-tab-stale-count]]) over relying on cmp/jobs page cards. If a cmp/jobs card must be opened, snapshot right after click and search the new snapshot's refs for a details heading, don't just re-eval body.innerText.
