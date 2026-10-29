---
name: indeed-notfound-dead-listing
description: Indeed cts email link in attached Chrome can land on "Not Found | Indeed" (viewjob 404 page) = dead listing; bare viewjob?jk= also Not Found
metadata:
  type: reference
---

Dead Indeed job via cts.indeed.com alert link: redirect lands on viewjob?jk=...&tk=... titled "Not Found | Indeed", body "We can't find this page". No isJobExpired flag/#jobDescriptionText in HTML. Corroborate by goto bare `viewjob?jk=<jk>` (also Not Found). Treat as closed/removed. Chrome attached on 9222 works; `tab-new "$(tr -d '\r\n' < file)"` passes a long URL from file safely. See [[indeed-blocked-clean-browser-attach-fallback]].
