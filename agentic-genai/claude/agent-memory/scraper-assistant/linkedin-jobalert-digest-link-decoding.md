---
name: linkedin-jobalert-digest-link-decoding
description: How to find and follow the specific job-listing tracked link inside a LinkedIn "jobs picked for you" / job-alert digest email
metadata:
  type: project
---

LinkedIn job-alert digest emails (sender jobalerts-noreply@linkedin.com, subject like
"Sr Software Engineer at <Company>") contain MANY tracked links — header nav icons
(feed/messaging/network/notifications), a top "Your job alert for X" search-results link,
and then one `/comm/jobs/view/<ID>/?trackingId=...` link PER company logo + PER job title
in the digest body. The email subject names only the FIRST job in the digest.

To find the right one: take a Gmail snapshot of the opened thread, search the yaml for
`link "<Job Title>` combined with the company name/city text right after it — the
row structure is company-logo-link, then a combined "Title Company · City Actively
recruiting" link, then the plain job-title-only link, all three pointing at the same
`/comm/jobs/view/<jobID>/?trackingId=...&refId=...` URL. Grab any one of these three
identical URLs and `playwright-cli goto` it directly (don't click through the UI —
faster and avoids losing your place).

**Bash quoting note**: these tracked URLs contain many `&`, `%3D`, `~` chars. In the
Bash tool (POSIX sh, not PowerShell) plain double-quoting the whole URL works fine —
do NOT use PowerShell's `--%` stop-parsing token in the Bash tool, it is not a valid
playwright-cli argument there and errors out.

Once on the `/comm/jobs/view/<ID>/...` page it 30x-redirects/renders as the normal
`linkedin.com/jobs/view/<ID>/` posting — `document.body.innerText` eval captures the
full "About the job" text directly, no need to click "…more" toggles (that toggle
just governs a company-insights card further down the page, not the job description
itself — the full description is already present in the initial DOM/innerText).

**Faster alternative to a Gmail snapshot (2026-08-05)**: when using the `mcp__claude_ai_Gmail__get_thread` tool directly (not browsing Gmail in-page), its FULL_CONTENT result is often too large for the tool-result token cap and gets written to a scratch `.txt` file instead of returned inline. Don't try to `grep`/`rg` that file directly for the target company name — the `htmlBody` is single-line HTML so line-based context flags (`-B`/`-A`) can't isolate a match. Instead load the file's `plaintextBody` field with Python (`json.load` then `pt.find('<Company>')`), which is digest-formatted as repeating `Job Title\nCompany\nLocation\n...\nView job: <url>` blocks — slicing ~300-400 chars before/after the company-name match reliably captures its `View job:` URL and thus the jobID, without wrestling the HTML at all. Confirmed across a 3-email GitHub-alert batch that mixed single-job alerts and multi-job digests.

See also [[linkedin-jobview-extraction]] and [[gmail-multi-account-thread-lookup]].
