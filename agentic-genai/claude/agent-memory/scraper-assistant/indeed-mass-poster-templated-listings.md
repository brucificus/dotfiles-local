---
name: indeed-mass-poster-templated-listings
description: High-volume gig posters (e.g. DataAnnotation) run near-identical job titles/descriptions across dozens of CO cities/pay bands on Indeed — direct site search recovers a specific listing after a stale tracked link, and Indeed's DOM has a recurring fake-looking placeholder data-jk that's a benign template artifact, not a real posting
metadata:
  type: reference
---

DataAnnotation (and similar "AI Trainer" gig-mill employers) post the same job description under dozens of title variants
("Software Designer - AI Trainer", "Data Analyst - AI Trainer", "Android Developer - AI Trainer", etc.) each cross-posted to many
individual CO cities (Greenwood Village, Fort Collins, Arvada, Westminster, Aurora, Denver, Centennial, Littleton, Thornton...),
all at the same $50-$100/hr pay band, all "Remote in <city>". The `#jobDescriptionText` body is byte-identical across every
city/title combination for this employer — confirmed by comparing Greenwood Village and Fort Collins postings for the same
title (jk differs, text is character-for-character the same). See also [[indeed-pagead-jrtk-stale-404]].

**Why:** When a tracked digest/email link 404s (stale jrtk), a direct Indeed search `q=<Company>&l=<City>` (or
`q=<Company> <Title>&l=<City>`) reliably re-finds the exact listing — read job cards via `[...document.querySelectorAll('[data-jk]')]`
mapped to `el.innerText` to get title+jk pairs, since `h2` selectors on search-result cards can come back empty depending on
Indeed's current markup.

**Separately:** one `[data-jk]` element per search-results page reliably shows `data-jk="456789abcdef0123"` — an obviously
fake/templated hex string. This is a benign Indeed ad-slot template default (seen attached to different, unrelated job titles
across different searches), not a hidden/injected listing — don't chase it down or treat it as suspicious content, just skip it
when harvesting real jk values.

**How to apply:** For any "gig mill" employer with a stale link, re-search company+title+city directly rather than guessing;
expect near-identical description text across postings, so cross-checking one instance is representative of the others.
