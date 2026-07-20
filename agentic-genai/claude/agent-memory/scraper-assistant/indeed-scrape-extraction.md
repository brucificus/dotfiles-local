---
name: indeed-scrape-extraction
description: How to reliably pull job description text, posting age, and apply-link href from a live Indeed viewjob page via playwright-cli.
metadata:
  type: feedback
---

Workflow for scraping a single Indeed `viewjob?jk=...` posting for archival into Obsidian notes (batch job-hunt task, see [[edge-attach-remote-debugging]] for browser connection):

1. **Open in a dedicated new tab**, not the operator's existing tabs: `playwright-cli -s=<session> tab-new "<url>"`. Don't touch/reload tabs the operator already had open — treat those as read-only context, they may be mid-task for the human.
2. **Job description body**: `eval "() => document.querySelector('#jobDescriptionText').innerText"` — this ID is stable on Indeed and returns clean verbatim text with real `\n` breaks.
3. **Apply link**: Indeed's "Apply on company site" / "Apply now" control is a `<button>`, NOT an `<a>` — `el.href` via eval on the ref returns `undefined`. Instead take a `snapshot`, grep the saved yml for `Apply`, find the button's `ref=eNNN`, then `eval "el => el.outerHTML"` on that ref and pull the `href="..."` attribute out of the raw HTML string (buttons carry it as a plain attribute, not the DOM `.href` property).
4. **Posting age**: many Indeed listings do NOT show a "Posted X days ago" relative string anywhere in `document.body.innerText` on the full viewjob page (that phrasing is more common on search-result cards), and it's often absent from visible metadata footers too. Two fallbacks, try both:
   - Look for an "Original Posting: MM/DD/YYYY - Until Filled" paragraph near the end of the description text and use that verbatim.
   - It's frequently embedded in a JSON blob inside `document.documentElement.innerHTML`, sitting right before a `"postedToday":true/false` key, e.g. `..."7 days ago","employerLastReviewed":null,...,"postedToday":false,...`. Extract via `const h=document.documentElement.innerHTML; const i=h.indexOf('postedToday'); h.slice(i-100,i+50)` and pull out the quoted phrase. Don't invent a relative-days phrase if neither is present.
5. **snapshot --filename=X.yml writes relative to the shell's cwd, not the vault-safe `.playwright-cli/` folder** — if cwd is the Obsidian vault root, this litters a stray `.yml` file directly in the vault. Always `rm` it immediately after grepping/reading it, or pass an absolute scratchpad path to `--filename` up front to avoid the cleanup step entirely.
6. If `attach --cdp=http://localhost:9222` errors with `EADDRINUSE .../pw-...-cli-...-default`, a stale daemon is holding the default session name — retry with a different `-s=<name>` (e.g. `-s=scrape`) rather than trying to kill/free the old one.
7. **Use `--raw` on every `eval`/`snapshot` call.** Without it, playwright-cli prints the FULL open-tabs list (can be 40+ entries when sharing a CDP endpoint with other parallel batches) before the actual result, burning huge context for no reason. `playwright-cli -s=<session> --raw eval "() => document.querySelector('#jobDescriptionText').innerText" > scratch.txt` then Read the file — much cheaper than parsing terminal noise. Use plain `snapshot` (no `--raw`) only when you actually need `ref=` handles to click something.
8. `document.body.innerText` also works as a fallback if `#jobDescriptionText` isn't present on a given page layout, but prefer the ID selector when available — it excludes nav/footer chrome.
