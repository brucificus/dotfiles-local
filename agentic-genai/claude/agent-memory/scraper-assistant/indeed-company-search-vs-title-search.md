---
name: indeed-company-search-vs-title-search
description: Indeed's bare company-name search can omit a live role that a title-specific query still returns; don't call a listing dead off the company search alone
metadata:
  type: feedback
---

On Indeed, `q="<Company>"` (company name only) is relevance-ranked and can silently drop a still-live posting from that same employer — especially a sponsored/pagead-sourced or lower-ranked role. Seen 2026-08-28: `q="Glint Tech Solutions"` returned only 2 of the company's roles; the target "Senior / Staff Full Stack Software Engineer – Remote" (jk=565b6234bfa7552e) was absent, yet `q=Glint Tech Solutions Senior Staff Full Stack Software Engineer&l=Remote` returned it immediately with "Easily apply" still active, and the direct `viewjob?jk=` page confirmed OPEN (`indeedApplyButtonContainer.disabled:false`, `postedToday:false`, `age:"30+ days ago"`, no expired flag anywhere in outerHTML).

**Why:** almost concluded "not in active search results" from the company search, which would have wrongly pushed the card toward Missed Opportunity.

**How to apply:** for a liveness check, run BOTH a company-name search and a title+location search, and always corroborate with the direct `viewjob?jk=<key>` page (apply-button `disabled` flag + hiringInsightsModel age + absence of expired/noLongerAvailable keys). Contrast [[indeed-company-jobs-tab-stale-count]] / [[indeed-company-page-js-cards]] which cover the cmp/<Co>/jobs tab being unreliable — this is the plain search box having the same failure mode.

**Small staffing-mill employers** (Glint Tech Solutions LLC, etc.) often run a `<slug>.careers-page.com` board (Careers-Page.com ATS) with many pages of unrelated reqs; WebFetch only sees page 1 and the board rarely mirrors the Indeed/LinkedIn-sponsored role, so its absence there is not evidence of closure.
