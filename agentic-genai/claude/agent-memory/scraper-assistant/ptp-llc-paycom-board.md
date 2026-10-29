---
name: ptp-llc-paycom-board
description: People Technology and Processes LLC (PTP GovCon) careers board = Paycom ATS; correct domain is ptp-llc.com not peopletech.com
metadata:
  type: reference
---

People, Technology & Processes LLC (PTP), Alexandria VA GovCon shop.

- Correct company site: **ptp-llc.com** (WordPress). `peopletech.com` is an unrelated firm ("People Tech Group").
- Careers page `ptp-llc.com/?page_id=2086` embeds a Paycom ATS widget via script src.
- Live board: `https://www.paycomonline.net/v4/ats/web.php/jobs?clientkey=F22E334739B721BD200B05E79DC87DE5&fromClientSide=true` -> redirects to `/portal/<clientkey>/career-page`.
- Job detail URL pattern: `/v4/ats/web.php/portal/F22E334739B721BD200B05E79DC87DE5/jobs/<numericId>`.
- SPA is **CSP-blocked in the attached (extension-laden) session** ("You need to enable JavaScript to run this app."). Use a clean unattached browser.
- Default listing shows all ~345 reqs tagged "Hot Job". Keyword filter: fill the **visible** input `#search-by-keyword-suggestion` then press Enter (the `Search by job title keyword` input is hidden/not visible). Board shows no posted dates.
- See [[attached-session-csp-blocking]], [[allied-benefit-paycom-ats]] (generic Paycom ATS notes), [[paylocity-recruiting-ats]].
