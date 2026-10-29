---
name: linkedin-guest-jobposting-api
description: linkedin.com/jobs-guest/jobs/api/jobPosting/<id> serves full JD text (incl. pay range + "No longer accepting applications" banner) even for EXPIRED listings, no auth, no CSP issues
metadata:
  type: reference
---

Endpoint: `https://www.linkedin.com/jobs-guest/jobs/api/jobPosting/<jobId>` in a fresh
unattached playwright-cli session (no login). `document.body.innerText` returns the complete
"About the job" text already expanded — intro paragraph, Responsibilities, Qualifications,
Benefits, EEO line, plus the "Base pay range" line and seniority/employment-type/industries
footer. One `--raw eval "document.body.innerText"` per id, pipe to a file.

Key advantages over `/jobs/view/<id>/`:
- Works on EXPIRED/removed listings. `/jobs/view/<id>/` redirects an expired req to a
  `?trk=expired_jd_redirect` search page (title hints the role, e.g. "Senior Staff Software
  Engineer Jobs..."), losing the JD. The guest jobPosting API still serves the cached full text.
- Sidesteps the attached-session extension CSP problem ([[attached-session-csp-blocking]])
  entirely since it's an unattached session.

Liveness read: if the guest API body contains "No longer accepting applications" => closed.
BUT absence of that banner is NOT proof of open — the guest API lags. Confirmed 2026-08-28
(Taylor Corp "Senior .Net Developer" id 4452885078): guest body showed only "1 week ago /
48 applicants / See who <Co> has hired for this role", no banner, while the AUTHENTICATED
`/jobs/view/<id>/` page (operator's logged-in LinkedIn) plainly showed "No longer accepting
applications" and did NOT redirect. So: the authenticated jobs/view page is the authoritative
closed/open signal; the guest API is best for the verbatim JD text. An expired req sometimes
redirects `/jobs/view/<id>/` to `?trk=expired_jd_redirect`, but a "closed but not purged" req
keeps its URL and just shows the banner. Caveat: after ~6-8 rapid logged-out requests the
guest session hits `/authwall?trk=qf...` — throttling, not a liveness signal.

Ladders (jobboard aggregator, appears as employer "Ladders" on LinkedIn) anonymizes the real
client: JD reads "For our client, we are seeking a <title> to join the team of a leader in the
<Industry> space." Sometimes the Benefits section leaks identifying awards (e.g. "2026 Gartner
Magic Quadrant Leader for Software Supply Chain Security" + "Fast Company Best Workplaces for
Innovators" => Sonatype). Ladders also re-posts the same underlying client req under multiple
LinkedIn job IDs over successive weeks with the SAME comp band and intro paragraph but
regenerated Responsibilities/Qualifications/Benefits bullet wording — treat matching pay-band +
matching intro across two IDs as "same real role, distinct listings".
