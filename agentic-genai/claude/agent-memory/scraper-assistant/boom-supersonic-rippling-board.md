---
name: boom-supersonic-rippling-board
description: Boom Supersonic careers ATS is Rippling, board slug `boom-supersonic`; jobs listed as Centennial CO (not Englewood)
metadata:
  type: reference
---

Boom Supersonic uses Rippling ATS. See [[rippling-ats-jobs-api]] for the mechanism.

- List API: `https://api.rippling.com/platform/api/ats/v1/board/boom-supersonic/jobs`
- Detail API: `.../board/boom-supersonic/jobs/<uuid>` (returns full JD, comp tiers, publishedAt)
- Public job page: `https://ats.rippling.com/boom-supersonic/jobs/<uuid>`
- LinkedIn offsite-apply links route through `linkedin.com/safety/go/?url=` wrapping the ats.rippling.com URL — decode to get the canonical req.

Notes:
- Rippling API blocks cross-origin fetch (CORS) when eval'd from another site's page; use WebFetch instead.
- Listings show location as **Centennial, CO** even when LinkedIn says Englewood, CO (adjacent; same HQ campus).
- "Software Engineer, Full Stack" (the "Boomie" integrated design/supply-chain/mfg platform) = job uuid `21b8325e-66aa-40e7-8fe7-c8ed7ab80af2`, published 2025-10-14, comp $130-175k (SWE) / $180-225k (Senior), ITAR. Evergreen ("no set deadline ... ongoing basis").
