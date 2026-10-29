---
name: globalpayments-worldpay-workday-boards
description: Global Payments Inc. and Worldpay run two separate Workday tenants post-merger; "Express"/"Launchpad" .NET eng roles are on the Worldpay wd5 tenant
metadata:
  type: reference
---

Global Payments Inc. and Worldpay merged and run TWO separate Workday tenants (applications don't cross over):

- **Worldpay** (use this for anything branded Worldpay, incl. the "Express" and "Launchpad" teams):
  tenant `worldpay`, host `worldpay.wd5.myworkdayjobs.com`, site `Worldpay_External_Careers_Site`
  - CXS list: `POST https://worldpay.wd5.myworkdayjobs.com/wday/cxs/worldpay/Worldpay_External_Careers_Site/jobs`
    body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"..."}` — **limit must be <=20** (limit:100 -> HTTP 400). `total` field is often bogusly 0 for broad searches; trust the jobPostings array + paginate by offset 20.
  - CXS detail: `GET .../wday/cxs/worldpay/Worldpay_External_Careers_Site/job/<externalPath>` -> `jobPostingInfo` has `jobReqId` (JR#######), `startDate` (posted), `canApply` (liveness), `remoteType`, `location`, `additionalLocations`, `jobDescription` HTML (pay range + US-citizen/GC wording live in the JD text).
  - Direct curl works but WAF rate-limits after ~4 hits with empty HTTP_400; fall back to `fetch()` from a tab already on the myworkdayjobs.com origin (attached session is fine, no CSP block on Workday).
- **Global Payments / TSYS**: tenant `globalpay`, `globalpay.wd1.myworkdayjobs.com/GlobalPaymentCareers`; also `tsys.wd1.myworkdayjobs.com/TSYS`. Aggregator front-end at jobs.globalpayments.com.

Worldpay Denver .NET IC roles seen 2026-08 (both DENVER, COLORADO primary + CINCINNATI, OHIO additional, Hybrid, no visa sponsorship, US citizen/GC only, pay $113,600-$171,575):
- JR0611151 "Senior Software Engineer - Backend (.Net)" (generic Worldpay JD) = LinkedIn 4450755506
- JR0610832 "Senior Software Engineer - .NET (Full Stack)" (Launchpad team, C#/ASP.NET Core/SQL Server/Vue-React-Angular, .NET Framework 4.x -> .NET 8 migration)
Older Express-team backend .NET req ($108,200-$163,400, Kafka/OpenShift/Azure+AWS) = LinkedIn 4441468938, went EXPIRED on LinkedIn and has no current ATS listing; JR0611151 is its successor.
