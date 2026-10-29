---
name: indeed-pagead-redirect-links
description: Indeed jobs-picked-for-you email pagead/clk/dl redirect links resolve cleanly via playwright-cli goto, no access issues observed
metadata:
  type: reference
---

Indeed "jobi2a_multijob" email redirect links (`indeed.com/pagead/clk/dl?...&jrtk=...&ad=...`) resolve directly to `indeed.com/viewjob?jk=<jobkey>` when navigated with `playwright-cli goto` on an attached Edge session — no interstitial, no block, no login wall observed (unlike `cts.indeed.com` tracked links, see [[indeed-cts-link-stale-redirect]] and [[indeed-status-verification]]). Same extraction approach as [[indeed-scrape-extraction]] applies: `#jobDescriptionText` innerText for body, `"expired":true/false` regex on outerHTML for liveness. Same-title/company postings at different locations can have byte-identical `#jobDescriptionText` — worth diffing before assuming a copy-paste error.

**Why:** Confirms this specific redirect family is safe to navigate directly for verbatim description + status checks, unlike cts.indeed.com links which can 403 or silently misredirect.

**How to apply:** When operator forwards Indeed job-alert-email redirect links (pagead/clk/dl pattern), navigate directly rather than routing around via WebFetch or asking the operator to hand-navigate.

**Title/body mismatch observed:** one posting's page `<title>`/H1 read "Java OpenTravel Alliance Developer- W2 Only" but `#jobDescriptionText` body clearly said ".NET OpenTravel Alliance Developer" / "Lead .NET Developer" throughout — same company (SSI People), same pay ($60-65/hr), same location (Remote/US). This is Indeed/poster template reuse, not a wrong-job redirect. Confirm identity via company+pay+body content, not the page title alone, before flagging a redirect as stale (contrast [[indeed-cts-link-stale-redirect]] where title+company truly didn't match).

**PowerShell `--%` breaks playwright-cli:** the stop-parsing token does not survive into the node CLI's own arg parser here — `playwright-cli --% goto "url&with&ampersands"` throws "Unknown command: <url>". Use the Bash tool (git bash/POSIX sh) instead for goto calls with multi-`&` query strings — plain double-quoting works fine there, no escaping needed.
