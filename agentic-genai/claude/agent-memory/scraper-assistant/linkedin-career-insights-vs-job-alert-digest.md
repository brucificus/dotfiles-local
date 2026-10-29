---
name: linkedin-career-insights-vs-job-alert-digest
description: LinkedIn sends two visually similar digest email types — distinguish "career insights" (no specific job postings) from "job alert" digests (has real /jobs/view/ links) before trying to extract a job card.
metadata:
  type: feedback
---

LinkedIn sends at least two different automated digest email types that both look like "jobs for you" emails at a glance:

1. **Job alert digest** (see [[linkedin-jobalert-digest-link-decoding]]) — subject like "X new jobs match your search" or similar, contains one tracked `linkedin.com/comm/jobs/view/<ID>` link per job card, each with a real title+company. These resolve to actual postings.

2. **Career insights digest** — subject like "Senior Software Engineer: Red Hat and Zoox hired roles near you", sent from `messages-noreply@linkedin.com`. Body sections are "X job trends from the past week", "Companies hiring for your role", "Companies searching for people like you", "Top trending companies", "Top skills from job postings". Despite naming specific companies and even a job title in the subject line, there is NO specific job requisition anywhere in this email — every company row link is `linkedin.com/comm/company/<slug>/jobs`, i.e. the company's generic jobs-search page, not a `/jobs/view/<ID>` posting. There is nothing to "follow through to the posting" because no posting is linked.

**Why:** Wasted a full click-through/status-check cycle assuming this was a job-card digest before reading `document.body.innerText`, which immediately reveals the "job trends" / "companies hiring" section headers characteristic of the insights format.

**How to apply:** Before treating a digest email's per-company/per-title block as an individual job posting, dump `document.body.innerText` (or check link hrefs for `/jobs/view/` vs `/company/.../jobs`) first. If all matching links are `/company/<slug>/jobs` (no numeric job ID), report to the user that the email only links to a generic company jobs page — do not guess at or search for a specific matching posting, and do not spend a browser round-trip opening it.
