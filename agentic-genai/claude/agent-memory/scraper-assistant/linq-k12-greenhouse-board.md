---
name: linq-k12-greenhouse-board
description: LINQ the K-12 EdTech SaaS (linq.com) uses Greenhouse board slug `emslinqinc`; disambiguate from the unrelated "Linq" digital-business-card company (linqapp.com / Ashby jobs.ashbyhq.com/linqapp)
metadata:
  type: reference
---

LINQ = K-12 school-operations software (finance/HR/nutrition/payments), linq.com,
legal entity "EMS LINQ Inc", HQ Wilmington NC, ~389 employees, eng org in Denver CO.

Careers page: `https://www.linq.com/company/careers/` (NOT `/careers/` — that 404s).
ATS: **Greenhouse**, board slug **`emslinqinc`**:
`https://job-boards.greenhouse.io/emslinqinc` — WebFetch works fine on the board index
and on `/emslinqinc/jobs/<numericId>`. A clean unattached playwright browser gets the
full verbatim JD via `document.querySelector('main').innerText`.

Do NOT confuse with "Linq" the digital-business-card startup (linqapp.com), which shows
up in the same searches with an Ashby board at `jobs.ashbyhq.com/linqapp` — different
company entirely.

Observed 2026-08-28 openings (8 total, mostly Denver): 2x "Staff Software Engineer" —
GH 5317298008 (mobile / React Native / Swift / Kotlin, $140-160K + 15%) and
GH **5373410008** (payments platform: Angular + Node + .NET/C# + Postgres + DynamoDB +
AWS, $160-180K + 15%, R&D dept). The 5373410008 posting's *header* says "Staff Software
Engineer" but its body opens "As a Senior Software Engineer at LINQ..." — same
title/body mismatch appears on its LinkedIn copy (LinkedIn job 4446508254, digest card
title "Staff Software Engineer", on-page title "Staff Software Engineer", body "Senior
Software Engineer"). LinkedIn 4446508254 has been getting weekly-reposted (shows
"Reposted 1 week ago") and re-surfaced in job-alert digests under the SAME id across
multiple deliveries — not a new req id each time, unlike [[linkedin-digest-weekly-repost-new-id]].
