---
name: linkedin-digest-weekly-repost-new-id
description: LinkedIn job-alert digests re-list the same role under a fresh job ID each delivery; the older ID's listing goes CLOSED while the employer ATS stays OPEN
metadata:
  type: reference
---

Same saved-search alert (savedSearchId in the unsubscribe link) delivered on two dates can
surface the SAME role under DIFFERENT LinkedIn job IDs — LinkedIn/the hirer re-posts weekly.
Confirmed 2026-08-28, CodePath "Staff Software Engineer": Aug 24 digest card 0 = id
4456680565, Aug 28 digest card 0 = id 4458373070. Both digests' `originToLandingJobPostings`
lists are otherwise entirely different companies (only CodePath recurs).

Liveness split you will see with these promoted reposts:
- The newest LinkedIn `/jobs/view/<id>/` (authenticated) shows "No longer accepting
  applications" + "Promoted by hirer - Responses managed off LinkedIn" within a day or two —
  LinkedIn closes its copy fast once the hirer routes applies to their own ATS.
- The guest jobPosting API for the same id ALSO already showed the closed banner here (not
  always lagging — contradicts the usual [[linkedin-guest-jobposting-api]] caveat).
- The employer's own ATS req is still OPEN. So the authoritative "can I still apply" signal
  for an ATS-routed ("Responses managed off LinkedIn") posting is the EMPLOYER ATS, not
  LinkedIn. Report both surfaces separately.

CodePath ATS = Greenhouse, board slug `codepath`:
`https://job-boards.greenhouse.io/codepath` (old `boards.greenhouse.io/codepath` 301s there).
WebFetch works fine on the board and on `/codepath/jobs/<reqid>`. There is also a Recruitee
board at `jobs.codepath.org/o/<slug>` but Greenhouse is the live one.
