---
name: orthofi-rippling-board
description: OrthoFi (orthodontic RCM/fintech, Denver CO) careers board is Rippling ATS, embed slug orthofi-open-roles
metadata:
  type: reference
---

OrthoFi careers page `orthofi.com/careers/` is WordPress/Elementor; the Open Positions section injects a Rippling Recruiting embed: `<div id="rr-job-board" data-job-board-id="orthofi-open-roles">` loading `ats.rippling.com/embed/orthofi-open-roles/jobs`.

- Board slug: `orthofi-open-roles` (NOT `orthofi` / `orthofi-llc` — those 404).
- Public board URL: https://ats.rippling.com/orthofi-open-roles/jobs
- List API: `https://api.rippling.com/platform/api/ats/v1/board/orthofi-open-roles/jobs` -> JSON array (uuid, name, department, workLocation, url).
- Detail API: append `/<uuid>` -> `description` is an OBJECT with `.company` and `.role` HTML keys; `createdOn` = posted date; `employmentType`; `workLocations`. `payRangeDetails` is `[]` (empty) — the salary lives as a "Compensation: $X - $Y annually" line inside the `role` HTML (Colorado Equal Pay Act boilerplate follows it).
- No short req/requisition ID exposed anywhere — only the uuid.
- KNOCKOUT screening questions live under `activeJobApplication.additionalQuestions[].form.questions`.

See [[rippling-ats-jobs-api.md]].
