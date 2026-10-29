---
name: lever-postings-api
description: Lever ATS public JSON API for employer-side job liveness and full verbatim JD
metadata:
  type: reference
---

Lever-hosted job boards (`jobs.lever.co/<slug>`) expose a public, unauthenticated JSON API — no CSP/attach problems, WebFetch works:

- `https://api.lever.co/v0/postings/<slug>?mode=json` — array of all open postings: `text` (title), `id`, `categories` (team, location, commitment, `allLocations`), `workplaceType` (onsite/hybrid/remote), `hostedUrl`, `createdAt` (ms epoch), `descriptionPlain`/`description`, `lists` (the bulleted sections), `salaryRange` if set.
- `https://api.lever.co/v0/postings/<slug>/<id>` — single posting, same shape, full description.
- A posting present in this feed = employer-side OPEN. Absent = pulled.
- Find the `<slug>` from the company careers page: look for `jobs.lever.co/<slug>/...` links (careers pages are often JS-rendered — use a browser eval or an unattached session if WebFetch returns an near-empty body).

Confirmed on `tagup` (slug = `tagup`, careers at tagup.ai/careers). `allLocations` can list many cities even when `categories.location` shows one — a LinkedIn card in a different city can still be the same Lever req.
