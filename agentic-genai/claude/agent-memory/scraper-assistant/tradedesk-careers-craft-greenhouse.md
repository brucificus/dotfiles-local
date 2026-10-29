---
name: tradedesk-careers-craft-greenhouse
description: The Trade Desk careers site is self-hosted Craft CMS + htmx front-end backed by Greenhouse board slug `thetradedesk`
metadata:
  type: reference
---

careers.thetradedesk.com/jobs is a self-hosted job board (Craft CMS: `/cpresources/.../htmx.min.js`; server-rendered, no third-party ATS chrome). Renders fine in the attached authenticated session — no CSP block.

- Listing URL: `careers.thetradedesk.com/jobs`. Filters: free-text `?q=<term>` (title/team weighted, does NOT index JD body reliably — searching "C#"/".NET"/"remote" returns junk or 0), `?page=N` (10/job page). Checkbox params `category[]=software-engineering`, `locations[]`, `type[]` exist in the form but do NOT filter via URL query — must click the htmx checkboxes.
- Detail URL: `careers.thetradedesk.com/jobs/<id>/<slug>`. Shows POSTED date, Location, Requisition ID (REQ-####), full JD. Salary range NOT shown in visible page text.
- Apply flow = Greenhouse: detail page embeds `job-boards.greenhouse.io/embed/job_app?for=thetradedesk&token=<id>`. The numeric `<id>` in the careers URL == Greenhouse job id.
- Authoritative data via `boards-api.greenhouse.io/v1/boards/thetradedesk/jobs/<id>?questions=false` — gives title, updated_at, location.name, absolute_url, metadata (Careers Site Category, Time Type). `pay_input_ranges` is empty; the base salary range is embedded as plain text inside `content` HTML ("The base salary range for this role is $X &mdash; $Y USD").
- REQ number (REQ-####) is only on the careers site, not in the Greenhouse API JSON.

See [[linq-k12-greenhouse-board]] [[smarterdx-greenhouse-not-ashby]] for other Greenhouse boards-api usage.
