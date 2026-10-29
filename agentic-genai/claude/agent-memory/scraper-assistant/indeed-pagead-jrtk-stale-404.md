---
name: indeed-pagead-jrtk-stale-404
description: Indeed pagead/clk/dl links with a stale/expired jrtk token 404 immediately (Whitelabel Error Page), no redirect attempt at all
metadata:
  type: reference
---

Unlike the case in [[indeed-pagead-redirect-links]] (fresh pagead/clk/dl links resolve cleanly to viewjob?jk=...), a stale or already-consumed jrtk
token causes the pagead/clk/dl request itself to return HTTP 404 with Indeed's Spring Boot "Whitelabel Error Page" (type=Not Found, status=404) —
`location.href` never changes from the original tracked URL, and the network request log shows the 404 directly on the pagead/clk/dl request
(no redirect chain at all, unlike the wrong-job-redirect failure mode of cts.indeed.com links).

**Why:** These single-use tracked links appear to expire or become invalid after some time/after first use, distinct from a truncated/malformed
jrtk (which the operator flagged as a possible cause but produced the identical symptom, so the two causes are indistinguishable from the outside).

**How to apply:** If a pagead/clk/dl goto returns a Whitelabel Error Page, don't retry or dig further — report it as a dead link and, if the user
wants the job content, ask for a fresher digest email/link or search Indeed directly for the company+title instead of trying to force the token.
