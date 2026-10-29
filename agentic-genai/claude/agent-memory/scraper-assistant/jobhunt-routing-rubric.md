---
name: jobhunt-routing-rubric
description: General workflow for routing job-hunt kanban leads to columns (To Apply / Difficult Fit / Disqualified / Missed Opportunity) in the Obsidian vault at D:\ObsidianVaults\Journal
metadata:
  type: project
---

Bruce runs a job-hunt kanban board in an Obsidian vault (D:\ObsidianVaults\Journal). Each lead is a note file at Resources/Kanban Tasks/<Company>.md. The master board file (e.g. "Y2026Q3 Job Hunt Outreach.md") is never edited directly by the scraping/routing agent — only individual company note files get a dated `### Log` entry recording the routing decision; a separate process moves cards on the board centrally based on that log.

Routing rubric (apply in order, stop at first match): dead/expired listing → Missed Opportunity; hard disqualifier while live (non-.NET backend stack, formal degree requirement, named security clearance tier — see [[public-trust-not-clearance-trigger]] for the Public Trust nuance, niche zero-overlap domain, or cultural red flag like commission/revenue-share comp) → Disqualified, Culture; narrower single-skill gap, vague/ambiguous stack, or scope pivot (hardware, mobile, security/QA-not-dev) → Difficult Fit; otherwise → To Apply; insufficient info anywhere → leave as Ideas (insufficient info).

**Why:** Many notes already carry scraped JD data from earlier sessions (stack, pay, clearance language) sufficient to apply the rubric without re-fetching. Only fetch (WebFetch first, browser tools if blocked) when the note is genuinely thin on stack/pay/status, or when the lead looks headed toward "To Apply" and its liveness needs confirming.

**How to apply:** Indeed listings that have expired show literal text "This job has expired on Indeed" when fetched — reliable signal for Missed Opportunity. LinkedIn listings don't always carry an explicit closure phrase even when stale (check for "no longer accepting applications" text); a live Apply button with no closure text is treated as still open even if posted months ago. See [[indeed-scrape-extraction]] and [[linkedin-jobview-extraction]] for extraction mechanics.
