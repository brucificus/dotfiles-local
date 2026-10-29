---
name: newton-paycor-recruiting-board
description: Newton Software / "Recruiting by Paycor" ATS — how to find the job board and reqs from a `?gnk=apply&gni=` apply link
metadata:
  type: reference
---

Legacy **Newton Software** ATS (now **Paycor Recruiting**, "A Paychex Company"). Tell-tale on a company's own careers page: an "Apply Now" link like `https://<company>.com/apply-for-employment/?gnk=apply&gni=<id>` (params `gnk` = Newton key, `gni` = Newton job id), plus an embed script referencing `newton.newtonsoftware.com/career/iframe.action?clientId=<32-hex clientId>`.

**How to enumerate the board (no auth needed, curl works):**
- `clientId` is a 32-char hex string in the iframe.action / page source.
- Career home: `https://newton.newtonsoftware.com/career/CareerHome.action?clientId=<clientId>` — 308-redirects to `https://recruitingbypaycor.com/career/CareerHome.action?clientId=<clientId>`.
- That page's job links: `https://recruitingbypaycor.com/career/JobIntroduction.action?clientId=<clientId>&id=<jobId>&source=&lang=en` (jobId is a 32-hex string, the only req identifier exposed).
- CareerHome renders the job list server-side enough that curl sees `<a href=...JobIntroduction...>` anchors; grep for `gni=` / `JobIntroduction`. Job **title, City, Department** are in the CareerHome table. If curl misses titles, render CareerHome in the browser and read `document.body.innerText` + anchor list.
- JobIntroduction body (the JD) is JS-rendered by the `gnewton` widget — use the authenticated browser, `document.body.innerText`. **No posted date, no salary, no numeric req ID** are shown on Newton/Paycor pages; only the hex `id`. Pay ranges seen elsewhere (e.g. Indeed) are syndication-added, not on the ATS.
- Feed endpoints (`CareerFeed.action`, `mobile/CareerPortalJson.action`, `ws/2.0/...`) all 404 now.

**Geneca (geneca.com)** uses this. clientId `8acda110393ef9d20139592c06304731`. Careers page `geneca.com/open_position/` is a WordPress archive that only ever shows a teaser card; the real board is the Paycor one above. As of 2026-08-30 Geneca had 2 open reqs total: "Full Stack .NET Software Developer" (Technology, Remote US, id `8a78879f7b7f6250017bd6d551821844`) and "Experience Analyst/Operations Specialist" (Operations, Remote US, id `8a78839e83fc5bfe01841222fcbc7aa7`).
