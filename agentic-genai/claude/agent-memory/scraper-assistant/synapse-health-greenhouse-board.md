---
name: synapse-health-greenhouse-board
description: Synapse Health (DME) careers ATS is Greenhouse board token `synapsehealth`; legacy Paylocity board is dead
metadata:
  type: reference
---

Synapse Health, Inc. (durable medical equipment) careers site is `synapsehealth.com/job-postings` — a WordPress/Divi page that embeds Greenhouse via `boards.greenhouse.io/embed/job_board/js?for=synapsehealth`.

- Liveness/JD without a browser: `https://boards-api.greenhouse.io/v1/boards/synapsehealth/jobs?content=true` (list) and `.../jobs/<id>` (detail). WebFetch-friendly, no CSP issues.
- Job URLs render as `synapsehealth.com/job-postings/<id>?gh_jid=<id>`.
- Legacy Paylocity board `recruiting.paylocity.com/recruiting/jobs/All/4ddfa6b0-fd20-4e70-8fe8-7c62fdd34376/Synapse-Health-LLC` now returns "that job does not exist or is not currently active" — treat as defunct, use Greenhouse.
- The `synapsehealth.com/job-postings` page itself renders blank via WebFetch and in an attached (CSP-injected) browser session — only the Greenhouse API reliably shows postings. See [[attached-session-csp-blocking]].

2026-08-28: board had only 2 reqs (both "Customer Experience Specialist"), no engineering roles. The "Senior Software Engineer" C#/.NET Remote role ($160K-$185K+) was gone from Greenhouse and LinkedIn but still live on Indeed (jk=0c8b73364136a6ae, isJobExpired:false).
