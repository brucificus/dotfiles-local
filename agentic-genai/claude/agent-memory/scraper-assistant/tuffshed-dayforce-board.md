---
name: tuffshed-dayforce-board
description: Tuff Shed careers = Dayforce HCM board `tuffshed`; default listing hides the tech role, use ?searchText= to surface it
metadata:
  type: reference
---

Tuff Shed, Inc. careers link on tuffshed.com/careers points to Dayforce HCM ATS.

- Portal: `https://jobs.dayforcehcm.com/en-US/tuffshed/CANDIDATEPORTAL`
- Keyword search via URL param: `?searchText=software%20developer` (works, returns "33 Results" style count + cards)
- Job detail URL pattern: `.../CANDIDATEPORTAL/jobs/<id>` (e.g. jobs/36484 = Sr Software Developer, Req #5692, National Support Center Denver CO)
- The default unfiltered board (~13 cards, Production/Sales/Ops roles) does NOT show the Sr Software Developer role — you must run a searchText query or it looks like there's no tech job.
- Attached CDP (9222) session: Dayforce board stuck on "Loading" forever (CSP block per [[attached-session-csp-blocking-general]]). Use an unattached extension-free browser — renders full list + detail fine.
