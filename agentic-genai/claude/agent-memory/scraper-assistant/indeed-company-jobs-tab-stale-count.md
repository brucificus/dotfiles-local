---
name: indeed-company-jobs-tab-stale-count
description: Indeed company page "/jobs" subpage text ("no open jobs currently") is itself unreliable, not just the nav badge count — cross-check with a direct q=<Company> search before concluding an employer has zero postings
metadata:
  type: reference
---

On an Indeed company page (indeed.com/cmp/<Company>), the top nav badge next to "Jobs" (e.g. "Jobs 2") is not reliable/live —
it can be stale in either direction. UPDATE: the /jobs subpage's own "There are no open jobs at <COMPANY> currently." text is
ALSO not reliable — confirmed false positive for "DataAnnotation Tech" (indeed.com/cmp/Dataannotation-Tech/jobs said no open
jobs) when a plain search `indeed.com/jobs?q=DataAnnotation&l=<city>` in the same session immediately turned up 15+ live
postings from that employer. Root cause looked like a company-name/slug mismatch ("Dataannotation-Tech" cmp page vs.
"DataAnnotation" as the actual poster name) rather than a genuine hiring freeze. See [[indeed-mass-poster-templated-listings]].

**How to apply:** Never conclude "no open jobs" from the /cmp/<Company>/jobs subpage alone. Always corroborate with a direct
`indeed.com/jobs?q=<Company Name>&l=<location>` search before reporting an employer has zero current postings — only treat it
as dead if BOTH the /jobs subpage says empty AND the direct q= search returns zero/unrelated results.

See also [[indeed-status-verification]], [[indeed-pagead-jrtk-stale-404]], [[indeed-mass-poster-templated-listings]].
