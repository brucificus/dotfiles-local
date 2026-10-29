---
name: serco-careers-phenom-site
description: Serco NA careers site (careers.serco-na.com, Phenom People) — how to check requisition liveness and why its keyword search is useless
metadata:
  type: reference
---

`careers.serco-na.com` is a Phenom People SPA. LinkedIn Serco listings say "Responses
managed off LinkedIn" and route applies here.

Liveness signal (reliable):
- Direct job URL form: `https://careers.serco-na.com/us/en/job/SUPSUAUS<reqID>EXTERNALENUS/<Title-Slug>`
  where `<reqID>` is the numeric "Job ID" shown on cards (e.g. 34465).
- A FILLED/removed req returns **HTTP 410 Gone** to WebFetch, and the SPA shows
  "We're sorry… the job you are trying to apply for has been filled." Both are solid
  "CLOSED" evidence.
- An open req renders "Position Description & Qualifications" body + "Apply Now".

Keyword search is effectively broken: `?keywords=<phrase>` returns ~all jobs (179–210)
ranked "Most relevant" with the target often not on page 1; quoting the phrase yields
0 results. `?sortBy=Most recent` in the URL is ignored. Don't rely on it to find a role.
Better: Google `site:careers.serco-na.com "<exact title>" <keyword>` to get the
`SUPSUAUS<reqID>...` URL directly, then hit that URL for the 410/200 liveness check.
To enumerate a domain: use `?category=Information%20Technology` (or Engineering) +
paginate with `?from=10&s=1&...`, `?from=20&s=1&...` — that listing is accurate.

Works fine in an unattached extension-free playwright session (no CSP problem, no login).

CMS eligibility / Federal Health Insurance Exchange dev + QA roles sit in Herndon, VA
20170 ("Virginia, US, 20170"). Serco tags most non-cleared roles "Other"; clearance
column shows Secret / TS-SCI / None explicitly.
