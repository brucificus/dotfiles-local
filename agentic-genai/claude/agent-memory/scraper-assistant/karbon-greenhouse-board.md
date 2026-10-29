---
name: karbon-greenhouse-board
description: Karbon (karbonhq.com, AI practice-mgmt SaaS for accountants) careers = Greenhouse board slug `karbon`
metadata:
  type: reference
---

Karbon (karbonhq.com) careers page links out to Greenhouse. Board slug = `karbon`.

- List: `https://boards-api.greenhouse.io/v1/boards/karbon/jobs?content=true` (add `?content=true` for JD + first_published)
- Detail: `https://boards-api.greenhouse.io/v1/boards/karbon/jobs/<id>`
- Public board: `https://job-boards.greenhouse.io/karbon/jobs/<id>`
- careers page `https://karbonhq.com/careers/` renders (no live listings, just "Express Your Interest" -> talent community GH id). `https://karbonhq.com/company/careers` 404s.

Quirks:
- Multi-location roles list named US metros (Austin, Chicago, Dallas, Denver, LA, San Diego, SF) rather than a "Remote, United States" location tag, even though Karbon is remote-first/globally distributed. Office field = "United States". Comp text: "we hire across various locations within the USA".
- Karbon runs near-duplicate security reqs: "Senior Security Engineer" (id 5987004004) and "AppSec Engineer" (id 6012153004) share identical JD + same $131k-$169k USD band; dept "Technology".
- `metadata` array carries "Opening ID (formally Planful ID)" and a "Multi Opening Second Salary" object (often all-zeros placeholder).

Indeed jk=69144aed2d582d49 ("Senior Security Engineer" at Karbon) is a syndication of GH 5987004004.
