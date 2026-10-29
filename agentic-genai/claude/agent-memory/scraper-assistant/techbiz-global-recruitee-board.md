---
name: techbiz-global-recruitee-board
description: TechBiz Global GmbH (staffing agency) job board is Recruitee at jobs.techbiz.global, NOT techbizglobal.com (parked/for-sale domain)
metadata:
  type: reference
---

TechBiz Global GmbH is a staffing/recruiting agency (real end employer undisclosed on aggregator postings).

- `techbizglobal.com` is a parked GoDaddy "for sale" domain — dead end, returns Access Denied / forsale redirect.
- Real corporate site: `techbiz.global` (careers at `techbiz.global/career/`).
- Real ATS job board: `https://jobs.techbiz.global/` — a **Recruitee** board. Individual postings live at `jobs.techbiz.global/o/<slug>`.
- Recruitee board renders fine in a clean unattached browser; the operator's attached session CSP-blocks it (body length 0). See [[attached-session-csp-blocking]].
- Posting slugs can contain typos (e.g. "Solutions Architect" was at `/o/solutions-architecht`). Filter `document.querySelectorAll('a')` by visible link text, not URL guessing.
- Each posting embeds `application/ld+json` JobPosting with `datePosted`; `validThrough` often null while open. Apply is a `<button>` (opens a modal form), no href.
- Same role often cross-posted verbatim to Indeed under TechBiz Global GmbH with a different location tag (e.g. Indeed said "San Francisco, CA"; Recruitee said "Austin, Texas +30 more") — description text is byte-identical.
