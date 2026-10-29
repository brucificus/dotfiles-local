---
name: cortex-io-greenhouse-board
description: Cortex (cortex.io, Engineering Operations Platform / IDP, Series C Scale Ventures, ~80-100 ppl, remote-US) careers = Greenhouse board slug `cortex`
metadata:
  type: reference
---

Cortex = cortex.io, "Engineering Operations Platform" / internal developer portal. NOT the same as
"Cortex by Palo Alto Networks" (Cortex XDR) — remoterocketship/some aggregators conflate them.

ATS: Greenhouse. Board slug `cortex`.
- Careers page: cortex.io/careers (renders the GH board)
- Public board API: https://boards-api.greenhouse.io/v1/boards/cortex/jobs  (add `?content=true` for full JD)
- Job detail API: https://boards-api.greenhouse.io/v1/boards/cortex/jobs/<id>
- Human URL: https://job-boards.greenhouse.io/cortex/jobs/<id>
- WebFetch works fine on the API (no auth, no CSP).

Observed 2026-08-31: 6 total open roles, all "Remote" / "we're fully remote and welcome candidates
from across the US" (no state exclusions seen). 3 are Engineering:
- Lead Software Engineer, Backend — id 5131543008 — $215,000-$245,000 starting base — posted 2026-02-24,
  updated 2026-08-06 — language-agnostic ("7+ yrs backend in any modern programming language", no
  Java/Go/Kotlin named). Also live on Indeed jk=dd8e0c6febe07337 ("isJobExpired":false).
- Senior Data Engineer — id 5380208008
- Staff Platform Engineer — id 5379820008 (infra/platform, not product backend)
Non-eng: BDR Manager, Manager Customer Engineering, Senior Professional Services Engineer.

History: an earlier "Senior Software Engineer, Backend" req ($165k-$195k, Indeed jk=25f60789859ccbd9)
was upleveled/replaced by the Lead-level version; the Senior Indeed posting shows
"This job has expired on Indeed" + "isJobExpired":true.
