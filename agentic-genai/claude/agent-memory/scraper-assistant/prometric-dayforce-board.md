---
name: prometric-dayforce-board
description: Prometric (testing/assessment co) careers ATS is Dayforce; public board is tiny and omits promoted LinkedIn eng roles
metadata:
  type: reference
---

Prometric's careers ATS is **Dayforce HCM** (Ceridian).
- prometric.com/careers links out to the old `dayforcehcm.com/CandidatePortal/en-IE/prometric/Site/prometriccareersite`, which 302-redirects to the new Next.js board at **https://jobs.dayforcehcm.com/prometric/prometriccareersite**.
- Backend tenant seen in asset URLs: `us252.dayforcehcm.com` / `us252.dayforcehcm.com/CandidatePortal/en-US/prometric/...`.
- The new board is a Next.js SPA — attached operator session (CSP-injecting extension) blocks its `_next` chunks entirely (`ERR_BLOCKED_BY_CLIENT` / `csp`), page stuck on "Loading". Use an unattached bundled-Chromium session; it renders fine there. See [[attached-session-csp-blocking]].
- Board is very small (~15 reqs total, no pagination, one "Read More" button per card). Req IDs are bare 4-digit numbers ("Req# 8090"). Most listings are Test Centre Administrator / Customer Service roles in Ireland/UK/US.
- `?keywords=` URL param does NOT filter; must use the on-page search box (`#searchText` + `[test-id=search-jobs-button]`).

Observed 2026-08-28: LinkedIn job 4417539736 "Sr Software Engineer" (Senior Software Engineer, Backend / Product Development / Remote USA / Python+Django+AWS) shows OPEN + "Promoted by hirer, Responses managed off LinkedIn" + reposted weekly, but this role is NOT on the Dayforce board at all. Only engineering title on the board was "Application Security Engineer" (Req# 8090, Dundalk Ireland). So Prometric routes some promoted eng roles through a channel that never hits the public ATS board — ATS absence alone does not prove the LinkedIn role is dead.
