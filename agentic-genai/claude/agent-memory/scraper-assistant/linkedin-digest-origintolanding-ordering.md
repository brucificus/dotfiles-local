---
name: linkedin-digest-origintolanding-ordering
description: LinkedIn job-alert digest emails encode card order in the originToLandingJobPostings= param; use it to map card position to job ID without clicking
metadata:
  type: reference
---

In a LinkedIn job-alert digest email (email_job_alert_digest_01), every tracked link carries `originToLandingJobPostings=<id>,<id>,<id>,...` — a comma-separated list of the ~6 job IDs in the SAME top-to-bottom order the cards appear in the email body. Also each card's own `/comm/jobs/view/<id>/` link has `..._jobid_<id>_ssid_...` in its trk param.

How to disambiguate which card is which company: read the plain-text body (company + location lines appear in card order), then zip that list against the `originToLandingJobPostings` ID list positionally. No need to hover/click individual cards.

Related: [[linkedin-jobalert-digest-link-decoding]]
