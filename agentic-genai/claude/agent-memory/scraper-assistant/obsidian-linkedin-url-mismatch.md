---
name: obsidian-linkedin-url-mismatch
description: Saved LinkedIn job URLs in Obsidian kanban note files can point to a different company's posting than the note's filename — always sanity-check the fetched page's company name against the note filename.
metadata:
  type: feedback
---

While batch-routing 32 kanban job-lead notes in an Obsidian vault, found at least one note (`Stem, Inc..md`) whose saved LinkedIn `/jobs/view/<id>/` URL actually resolved to a posting for an entirely different company ("High Country Search Group", a recruiting agency). This is a real data-quality artifact, not scraper error — likely from an earlier batch-scraping session that mislabeled which URL belonged to which company file.

**Why:** trusting the filename-to-URL mapping blindly would propagate a wrong routing decision (or wrong JD content) into the permanent note, and the operator explicitly relies on these notes as the source of truth for a downstream board-move step.

**How to apply:** when live-checking a saved URL, glance at the page's company name/header before writing the log entry. If it doesn't match the note's filename, say so explicitly in the log entry (e.g., "the saved URL resolves to an unrelated company's listing") rather than silently treating the fetched content as this company's own. When ground-truthing which URL belongs to which company across many files in one session (e.g. after losing context/compaction), `grep -o 'https://www.linkedin.com/jobs/view/[0-9]*' "<file>"` per file is a fast, cheap way to build an authoritative URL-to-filename map before doing any live fetching — do this proactively for a large batch rather than trusting memory/notes of "which URL I fetched for which company," which is easy to mix up across many sequential fetches in a single session.
