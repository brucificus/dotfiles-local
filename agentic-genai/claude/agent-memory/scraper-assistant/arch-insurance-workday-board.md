---
name: arch-insurance-workday-board
description: Arch Insurance / Arch Capital careers ATS is Workday tenant archgroup/wd1 site Careers; CXS API gives full JD + liveness
metadata:
  type: reference
---

Arch Insurance Group Inc. / Arch Capital careers run on **Workday**, tenant `archgroup`, pod `wd1`, site `Careers`.

- Public board: https://archgroup.wd1.myworkdayjobs.com/en-US/Careers
- Job page pattern: https://archgroup.wd1.myworkdayjobs.com/en-US/Careers/job/<slugpath>_<ReqID> (req IDs look like `R26_673`)
- CXS list API: POST https://archgroup.wd1.myworkdayjobs.com/wday/cxs/archgroup/Careers/jobs  body `{"appliedFacets":{},"limit":20,"offset":0,"searchText":"..."}`
- CXS detail API: GET https://archgroup.wd1.myworkdayjobs.com/wday/cxs/archgroup/Careers/job/<externalPath>  -> jobPostingInfo has jobReqId, jobDescription (HTML), location, additionalLocations, startDate, canApply, posted.
- The internal Arch "job code" (e.g. 14400) is buried as a bare number near the end of jobDescription HTML, distinct from the Workday ReqID.

Per [[workday-cxs-jobs-api]]: attached Brave/Edge session and WebFetch both 403 on Workday. Use an **unattached** extension-free browser; navigate to the Careers domain first, then `fetch()` the CXS endpoints same-origin (fetch from about:blank fails CORS).

CXS `searchText` is fuzzy/low-precision (a query for "C#" returned 168 mostly-unrelated hits). To enumerate roles by tech stack, filter titles to real SWE roles, fetch each detail, and regex the description yourself.
