---
name: northramp-workable-board
description: Northramp LLC (GovCon) careers board is a Workable embed, account ID 731558; use the widget JSON feed for liveness
metadata:
  type: reference
---

Northramp LLC (northramp.com, DC federal-consulting shop) hosts jobs on **Workable**.

- Careers page: northramp.com/careers -> northramp.com/open-positions (Squarespace; embeds legacy Workable "whr" widget into `#whr_embed_hook`). Inline config: `whr_embed(731558, {...})`.
- Attached operator session CSP-blocks the Workable SPA (`apply.workable.com/...` renders blank, body length 0) — see [[attached-session-csp-blocking]]. Use the API instead.
- **Liveness feed (no auth, WebFetch-friendly):** `https://www.workable.com/api/accounts/731558` 302-redirects to `https://apply.workable.com/api/v1/widget/accounts/731558` — returns JSON `jobs[]` of only published/open reqs with title, shortcode, `published_on`, locations, telecommuting. Presence in this list = OPEN.
- Individual posting: `https://apply.workable.com/northramp/j/<SHORTCODE>` (SPA, blank in attached session; WebFetch renders the JD fine).
- 2026-08-30 snapshot: "Software Developer" (shortcode E0C94AD817, remote, DC, published 2026-06-16) is OPEN — this is the ASP.NET MVC / federal-clients role also posted on Indeed jk=e98349b6001bf9a7. Other open reqs: Full Stack Developer, Data Engineer (BigQuery), Data Scientist (Looker/AI/BI), QA Automation Engineer, Talent Network.
