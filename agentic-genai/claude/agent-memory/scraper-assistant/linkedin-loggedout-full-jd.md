---
name: linkedin-loggedout-full-jd
description: LinkedIn jobs/view pages show full JD text via body.innerText even in a fresh logged-out browser session, no auth needed
metadata:
  type: reference
---

A brand-new unattached/unauthenticated playwright-cli browser session (no LinkedIn login) hitting a `linkedin.com/jobs/view/<id>/` URL still renders the complete "About the job" / full description text in `document.body.innerText` — confirmed working without sign-in. Useful when the operator's attached session is blocked by extension CSP (see [[attached-session-csp-blocking]]) — just open a fresh session rather than trying to route through the authenticated attached browser. Applicant count, "Reposted/X days ago", pay range, employment type, and seniority level are all present in logged-out view too.
