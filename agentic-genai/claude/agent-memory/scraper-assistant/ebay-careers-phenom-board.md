---
name: ebay-careers-phenom-board
description: eBay Inc (incl. TCGplayer) careers = Phenom People site jobs.ebayinc.com; how to search it and its quirks
metadata:
  type: reference
---

eBay Inc.'s careers site (covers eBay, TCGplayer, Roca robotics) is **Phenom People**:
`jobs.ebayinc.com/us/en/search-results?keywords=<term>` and detail pages
`jobs.ebayinc.com/us/en/job/<ReqID>/<slug>` where ReqID looks like `R0076084`.

- SPA is **CSP-blocked in the operator's attached browser** (empty body) — use a clean unattached `playwright-cli open`. Renders in ~3-4s.
- Keyword search is fuzzy/OR: `keywords=Team Lead` returns ~355 results (matches "team" or "lead" anywhere). Use `keywords=Longmont` or exact phrases to narrow. Location search works well as a keyword.
- Detail page shows: title, location, category (e.g. "IT & Technical Operations" / "Engineering"), ReqID, Onsite/Hybrid/Remote, Apply Now button. "Base pay range ... expected in the range below:" is often followed by a literal "-" (range hidden). Posted date frequently not in body text.
- No public JSON API endpoint found (`/api/jobs?...` returns HTTP 500). Scrape the rendered anchors: `a[href*="/job/"]`.
- `tcgplayer.com/careers` 404s and `careers.tcgplayer.com` is dead — TCGplayer roles are all on jobs.ebayinc.com now (search `keywords=TCGplayer`).
- The Roca team (automated trading-card sorting robots, Longmont CO) has almost no SWE footprint on the board — as of 2026-08 only "Mechanical Production Support Engineer" (Longmont, Onsite, IT & Technical Operations) matched Longmont/robotics.
