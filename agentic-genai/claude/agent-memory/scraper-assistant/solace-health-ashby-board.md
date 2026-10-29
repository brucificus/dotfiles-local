---
name: solace-health-ashby-board
description: Solace (solace.health, patient-advocacy healthcare startup) ATS is Ashby, job-board slug `solace`
metadata:
  type: reference
---

Solace Health (solace.health, Series C patient-advocacy healthcare startup, founded 2022) uses Ashby.

- Job-board slug is `solace` (NOT `solace-health` / `solacehealth` — both 404).
- Public API: `https://api.ashbyhq.com/posting-api/job-board/solace?includeCompensation=true` — returns JSON list of listed reqs w/ id (UUID), title, location, isListed, isRemote, publishedAt, compensation (often empty tiers — Solace does not publish salary).
- Direct job URL form: `https://jobs.ashbyhq.com/solace/<uuid>` ; apply: `.../<uuid>/application`.
- See [[ashby-posting-api]] for general Ashby API notes.

As of 2026-08-30: board had 28 open reqs, heavy on "College Grad 2027" associate roles + clinical + legal. Engineering reqs present: Senior Platform Engineer, Sr. Security Engineer (Detection), several Associate (grad) eng roles, Technical Product Manager. NO "Staff Software Engineer" — that role (LinkedIn 4329793998) had closed; LinkedIn showed "No longer accepting applications".
