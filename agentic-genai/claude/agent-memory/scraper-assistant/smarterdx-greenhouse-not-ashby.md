---
name: smarterdx-greenhouse-not-ashby
description: SmarterDx (clinical-AI, NYC) hosts its job board on Greenhouse slug `smarterdx`, NOT Ashby; jobs.ashbyhq.com/smarterdx 404s
metadata:
  type: reference
---

SmarterDx careers ATS = **Greenhouse**, board slug `smarterdx`.

- Board page: `https://job-boards.greenhouse.io/smarterdx`
- List API (no auth, WebFetch/unattached-browser friendly): `https://boards-api.greenhouse.io/v1/boards/smarterdx/jobs` -> `{jobs:[{id,title,location.name,updated_at,absolute_url}]}`. API only returns live reqs, so presence == open.
- Detail API: `https://boards-api.greenhouse.io/v1/boards/smarterdx/jobs/<id>` -> `.content` is HTML-entity-encoded full JD (decode &lt; &gt; &amp; &#39; then read innerText). `pay_input_ranges`/`metadata` were null on the reqs checked; comp is inline in the JD body ("$190K to $220K base salary").
- `jobs.ashbyhq.com/smarterdx` returns **Page not found** (404) — do NOT assume Ashby for this employer even if a task says so.
- smarterdx.com/careers renders the Greenhouse rows client-side, each linking to job-boards.greenhouse.io/smarterdx/jobs/<id>.
- Indeed pulls SmarterDx listings straight from Greenhouse; Indeed JD text is byte-equivalent to the Greenhouse `.content`.
- LinkedIn only carries a partial subset of the Greenhouse reqs (company f_C=79991214). Several Greenhouse eng roles (e.g. "Senior Software Engineer, Platform Infrastructure", the two Backend SWE roles) had no LinkedIn posting at all as of 2026-08. Don't treat "absent from LinkedIn" as "closed".

Related: [[ashby-posting-api]]
