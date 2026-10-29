---
name: seismic-careers-sitecore-nextjs
description: Seismic (seismic.com) careers is a self-hosted Sitecore + Next.js SPA, no third-party ATS; how to scrape its job list and detail
metadata:
  type: reference
---

Seismic's careers site is NOT on Greenhouse/Lever/Workday/Ashby. Greenhouse slugs `seismic` and `seismicsoftware` both 404. It is a self-hosted Sitecore-backed Next.js SPA at `https://www.seismic.com/careers/job-listings/`.

- Listings page and detail pages are pure client-rendered; attached operator browser (Edge/Brave w/ CSP-injecting extension) is blocked (`script-src-elem 'none'`) and shows only "Loading component...". Use an unattached clean `playwright-cli open` browser.
- Job list renders as `<a href="/careers/job-detail/?jid=<JID>&pid=<PID>">` rows grouped by department. `pid=17` = US/Remote external roles, `pid=206` = Hyderabad/India roles (observed 2026-08).
- List is collapsed per-section; click the "See more" button (role=button, name "See more") to expand hidden rows before scraping — page header states the true total ("21 roles showing...").
- Detail page `/careers/job-detail/?jid=<JID>&pid=<PID>` renders full JD in body.innerText after ~5s. Apply is a "US Application" link opening a new tab (that's the real ATS/form step - do not follow for liveness checks).
- No req/R-number and no posted-date are shown on the detail page; the only stable identifier is the `jid`.
- Pay range: the JD contains the sentence `Seismic's salary range for this position is: -` with the range left blank on both LinkedIn and the ATS (confirmed 2026-08 for a US-Remote senior SWE role). So "no pay range shown" is the norm here, not an omission.
- Next.js data endpoint `https://www.seismic.com/_next/data/<BUILDID>/en/careers/job-listings.json?path=careers&path=job-listings` returns 200 but is a giant Sitecore layout blob; parsing the rendered DOM is easier than the JSON.
- Note (2026-08): "Seismic and Highspot are now one company" banner - a merger is in progress.
