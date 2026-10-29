---
name: hone-health-greenhouse-board
description: Hone Health (honehealth.com telehealth/longevity clinic) careers = Greenhouse board slug `honehealth`; boards-api JSON; honehealth.com/careers just links out to it.
metadata:
  type: reference
---

Hone Health ATS = **Greenhouse**, board slug `honehealth`.

- List: `https://boards-api.greenhouse.io/v1/boards/honehealth/jobs?content=true`
- Detail: `https://boards-api.greenhouse.io/v1/boards/honehealth/jobs/<id>`
- Public board: `https://job-boards.greenhouse.io/honehealth`
- `honehealth.com/careers` renders no postings itself; just a link out to the Greenhouse board.

Notes:
- Remote-first from day one. Most reqs `location.name` = "Remote"; a few say "Remote (US ONLY)" / "Fully Remote (US Only)". The .NET role just says "Remote" (no explicit geo in JD).
- Pay range is inline in `content` HTML under a "Compensation Range" heading, not in Greenhouse metadata.
- `updated_at` is bulk-stamped (many reqs share one timestamp from a board migration), so it's a weak recency signal.
- 2026-08-31: 14 open roles. Eng/data IC roles: Senior Software Developer - .NET ($120-150k, id 4781850008, C#/.NET Core + SQL Server/Azure SQL + EF + Razor, remote), Staff Cloud Engineer, Quality Engineer II ($80-105k, test automation, mentions .NET/C#), Data Architect, Contract Data Engineer, Data Engineering Intern, 2x Senior Data Scientist. Only the "Senior Software Developer - .NET" req is a core C#/.NET IC role.
- That req is also the one cross-posted to LinkedIn ("Promoted by hirer · Responses managed off LinkedIn" -> apply offsite via Greenhouse).
