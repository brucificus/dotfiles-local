---
name: emergent-software-recruitee-board
description: Emergent Software / Emergent Staffing (MN Azure consultancy + staffing arm) careers ATS is Recruitee, board slug emergentsoftware
metadata:
  type: reference
---

Emergent Software (emergentsoftware.net) and its staffing arm Emergent Staffing run one shared job board on **Recruitee**: `https://jobs.emergentsoftware.net/` with posting URLs `jobs.emergentsoftware.net/o/<slug>`. `emergentstaffing.net/job-seekers/open-jobs/` is a mirror feed of the same reqs.

- Recruitee `/o/<slug>` returns HTTP 404 once a req is closed/filled/pulled — a clean liveness signal.
- The `#INDxx` hashtag from syndicated Indeed listings (e.g. #IND55, #IND66) appears inline in the Recruitee JD body text; it is an Indeed-syndication reference tag, not a Recruitee req ID.
- Verify ATS quickly: job-detail page outerHTML contains `recruitee`.

Seen 2026-08-30: "Lead Software Engineer" API-platform direct-hire role (#IND55, slug `lead-software-engineer-3`, comp $140-160k, TS+AWS) was 404 on Recruitee and absent from the listing = CLOSED, matching Indeed's expired banner + `"isJobExpired":true`. See [[indeed-status-verification]].
