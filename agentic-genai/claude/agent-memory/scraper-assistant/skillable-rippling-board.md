---
name: skillable-rippling-board
description: Skillable (remote lab/training tech co) careers = Rippling ATS board slug `skillable-careers`
metadata:
  type: reference
---

Skillable's careers page (skillable.com/company/careers/) embeds a Rippling job board via
`static-assets.ripplingcdn.com/ats/embeds/job-board.v1.js`, div `#rr-job-board`
`data-job-board-id="skillable-careers"`.

- List: `https://api.rippling.com/platform/api/ats/v1/board/skillable-careers/jobs` (JSON, works through attached session, no CSP issue)
- Detail: `.../jobs/<uuid>` — gives description HTML, `workLocations`, `createdOn`, `employmentType`, plus the application KNOCKOUT questions which carry the 25-state residency list and remote-workspace requirement.
- `payRangeDetails` is an empty array on this board — Skillable does NOT publish salary on Rippling; the $130k-$150k range only appears on the syndicated Indeed/aggregator posting.
- Public board UI: `https://ats.rippling.com/skillable-careers/jobs`; per-job `https://ats.rippling.com/skillable-careers/jobs/<uuid>`. Req "ID" is just the UUID (no short number).

See [[rippling-ats-jobs-api]] for the general Rippling pattern.
