---
name: marketing-com-colorart-paycor-board
description: "Marketing.com" (print/direct-mail rollup, formerly Color Art) careers = Recruiting by Paycor / Newton board; clientId 8a7883d07acff70f017b324086af22f8
metadata:
  type: reference
---

"Marketing.com" is a multi-plant commercial print / direct-mail / warehousing-fulfillment rollup (30+ US/Canada facilities: Breese IL, Eureka MO, Fond du Lac WI, Hagerstown MD, Torrington CT, Walled Lake MI, Ontario CA, Cayce SC, Gainesville VA, Des Moines IA, Peru IN, Jonesboro AR, Hauppauge NY). The Paycor account traces back to **Color Art** (colorart.com, now NXDOMAIN) — `CareerHome.action` used to redirect there.

**ATS = Recruiting by Paycor (Newton Software).** No Greenhouse/Lever/Ashby/Workday/iCIMS (all probed, negative).

- Public marketing careers site: `https://careers.marketing.com/` (WordPress; `/open-positions/` embeds the ATS). Note: whole `careers.marketing.com` site was returning site-wide **HTTP 503 from awselb/2.0** during the 2026-08-31 check — dead backend, not bot-blocking. Use Wayback + the Paycor URL directly instead.
- Job board (works via curl, renders server-side HTML with full job rows):
  `https://recruitingbypaycor.com/career/CareerHome.action?clientId=8a7883d07acff70f017b324086af22f8`
- Detail page: `.../career/JobIntroduction.action?clientId=8a7883d07acff70f017b324086af22f8&id=<hex>&source=&lang=en` — HTTP 200 = live; page shows "Job Id: <short int>" (e.g. Automation Support Specialist = Job Id 1782), "# of Openings", location, full JD. No salary on Paycor detail (Indeed carried the pay band).
- `iframe.action?clientId=...` returns raw JS (not usable); use `CareerHome.action`.

Board is overwhelmingly production-operator / warehouse / sales / CSR roles (~60 open). Essentially zero dedicated software/developer/IT postings — the lone technical role is "Automation Support Specialist" (Remote), which the JD itself calls "not primarily a development role" (C#/.NET only "highly preferred" growth path).
