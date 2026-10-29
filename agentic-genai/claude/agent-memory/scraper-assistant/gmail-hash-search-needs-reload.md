---
name: gmail-hash-search-needs-reload
description: Gmail SPA search via URL hash or typed query often doesn't filter the list until you reload
metadata:
  type: feedback
---

When driving Gmail in an attached browser:

- Navigating to `https://mail.google.com/mail/u/<n>/#search/<terms>` (or filling `input[name=q]` + Enter, or clicking the Search button) frequently leaves the message list showing **All Mail unfiltered** — the search box shows your text but `tr.zA` rows are the full inbox.
- Fix: after setting the hash/typing, call `playwright-cli reload`. The search then actually executes and `tr.zA` rows become the filtered results.
- A direct thread permalink like `#all/<hex-legacy-id>` from an email's "view in browser" link may not resolve at all (lands on All Mail list). Fall back to searching by subject/sender text, then click the row; the resulting URL gives a working `#all/<FMfcgz...>` permalink for that account/`u/N`.

**Why:** wasted several calls thinking the account lacked the message when the search just hadn't run.
**How to apply:** always `reload` after a Gmail hash-search; expect legacy hex thread IDs to fail and pivot to text search.

Related: [[gmail-multi-account-thread-lookup]]
