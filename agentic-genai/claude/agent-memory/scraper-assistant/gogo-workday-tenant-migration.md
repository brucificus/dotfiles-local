---
name: gogo-workday-tenant-migration
description: Gogo Business Aviation moved its Workday careers site from gogoair.wd1 to gogo.wd503; old req IDs 404, roles re-posted under new R-numbers
metadata:
  type: reference
---

Gogo Business Aviation (gogoair.com) migrated Workday tenants. The old site
`gogoair.wd1.myworkdayjobs.com` is dead — old requisition IDs (e.g. R3987) return
"The page you are looking for doesn't exist."

Current live board: **`gogo.wd503.myworkdayjobs.com`**, site slug `careers`.
- Human: `https://gogo.wd503.myworkdayjobs.com/en-US/careers`
- CXS API: `POST /wday/cxs/gogo/careers/jobs` and `GET /wday/cxs/gogo/careers/job/<path>` — see [[workday-cxs-jobs-api]]. Works fine from an unattached fresh browser via `page.evaluate`.

Gotcha: the same role gets re-posted under a new R-number, and Workday's
`externalPath` slug can be stale/mismatched — e.g. "Senior Airborne Platform
Software Engineer" (jobReqId R4138) lived at a URL slugged
`Senior-Airborne-Platform-Automation-Test-Engineer_R4138-1`. Trust
`jobPostingInfo.title` + `jobReqId` + `canApply`, not the URL slug.

**How to apply:** For any Gogo liveness check, skip gogoair.wd1 entirely; hit the
wd503 `gogo/careers` CXS API and match by title, not by old req ID or slug.
