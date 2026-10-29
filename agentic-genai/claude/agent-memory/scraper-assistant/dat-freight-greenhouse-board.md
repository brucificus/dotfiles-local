---
name: dat-freight-greenhouse-board
description: DAT Freight & Analytics careers = Greenhouse board slug `datsolutions` (not dat/datfreight); careers.dat.com/jobs is the embed
metadata:
  type: reference
---

DAT Freight & Analytics (www.dat.com, freight/logistics SaaS; offices Portland OR, Denver CO,
Seattle WA, Springfield MO, Mississauga/Toronto ON, Bengaluru IN).

- Careers site: `https://careers.dat.com/jobs` — a Greenhouse embed (job links carry `?gh_jid=`).
- Greenhouse board slug: **`datsolutions`** (legal entity DAT Solutions LLC). Slugs `dat`,
  `datfreight`, `datfreightanalytics`, `dat-freight-analytics` all 404.
- List: `https://boards-api.greenhouse.io/v1/boards/datsolutions/jobs` (add `?content=true` for bodies).
- Detail: `https://boards-api.greenhouse.io/v1/boards/datsolutions/jobs/<id>` — `content` is
  DOUBLE HTML-entity-encoded (`&lt;` etc. inside the JSON string); decode twice then strip tags.
- Job IDs on the careers site display as either legacy `Job ID 14xx` or newer `Job ID 2026-0xx`,
  but the Greenhouse numeric id (10 digits, in `gh_jid`) is the stable key.
- Salary: in the JD body as a state-law pay-transparency paragraph ("for Colorado-based
  candidates, in compliance with the Colorado Equal Pay for Equal Work Act, the salary range
  for this role is $X - $Y + target bonus"). Seattle roles quote the WA law range instead.
  `metadata[].name == "Annual Bonus %"` sometimes populated (e.g. "10%").
- LinkedIn company id: `f_C=8027` (company slug `dat-freight-and-analytics`). All DAT US
  engineering roles are office-hybrid (Denver / Seattle / Portland) — no US-remote eng roles;
  only non-eng roles (Carrier Success Mgr, CSM) are "Remote - USA".
- Stack by team: US eng = Node.js / TypeScript / Java / Python / Go / Angular / React / AWS /
  Kafka / Snowflake. The ONLY C#/.NET role is the Mississauga ON "Principal Software Engineer"
  (.NET Core / C# + Angular + Azure + SQL Server / MySQL / PostgreSQL) — Canada, hybrid, not
  US-remote.
