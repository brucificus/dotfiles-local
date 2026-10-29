---
name: paylocity-recruiting-ats
description: Paylocity's own careers site + self-hosted Paylocity Recruiting ATS — how to list/verify reqs
metadata:
  type: reference
---

Paylocity (the HR/payroll SaaS company) hosts its own jobs on its own product, "Paylocity Recruiting".

- Public careers index: www.paylocity.com/company/careers/all-listings/ (SPA). Free-text filter works via query param `?t=<terms>` (e.g. `?t=Staff%20Engineer%20Software`) — no need to submit the form. Page shows an accurate "<N> results" count and renders matching cards with location suffix ("- Remote, US", "- Guadalajara, Mexico").
- Each card links to `https://2000recruiting.paylocity.com/recruiting/jobs/Apply/<reqID>/Paylocity/<slug>` (numeric reqID, e.g. 45000). The `2000` host prefix = Paylocity's own company id on the platform.
- JD detail page: swap `/Apply/` for `/Details/` — `.../recruiting/jobs/Details/<reqID>/Paylocity/<slug>`. Full JD in body.innerText, plus "Fully Remote • Remote, US • Product & Technology" location line and an active "Apply" button = OPEN. Dead/closed req => redirects to `/Recruiting/jobs/JobNotFound` ("that job does not exist or is not currently active").
- The recruiting.paylocity.com SPA (both Apply and Details) needs JS and is blocked by the operator's attached-session injected CSP ("necessary to enable JavaScript" message). Use an unattached clean browser. www.paylocity.com/company/careers SPA also fails to client-side filter in the attached session but the first ~10 cards still render.
- `playwright-cli open` with `--browser=chrome` fails on this machine (no Chrome install); plain `playwright-cli open` (bundled chromium) works for an unattached session.
