---
name: gmail-multi-account-thread-lookup
description: A Gmail thread/message URL's authuser= or u/<N> may not match the account that actually holds the thread when multiple Google accounts are signed into the same browser profile
metadata:
  type: reference
---

Gmail URLs like `https://mail.google.com/mail/u/<N>/#inbox/<threadId>` (or `?authuser=<email>#inbox/<threadId>`) encode a per-browser-profile account index `<N>`, not a guaranteed binding to the email address in `authuser=`. If several Google accounts are signed into the same browser profile, `u/0`, `u/1`, etc. can point to entirely different accounts than expected, and a thread ID that's valid under one account will silently fail under another.

Symptom: navigating to the URL loads Gmail successfully (correct account title, no error banner) but the target thread never appears — Gmail just falls back to showing the generic Inbox/Primary view with unrelated messages.

Diagnostic: run `playwright-cli console` after the failed navigation. A 404 from Gmail's internal API `itemServerPermIdFromLegacyThreadStorageId?messageIdForThreadBasedUi=<decimalThreadId>` confirms the thread genuinely does not exist under the currently active account index — this is not a rendering/timing bug.

Fix: retry the same thread ID under other `u/<N>` indices in the same profile (e.g. `u/0`, `u/2`, ...) until one resolves — Gmail will auto-rewrite the URL hash to its opaque thread ID format (e.g. `#all/FMfcgz...`) on success. Check `document.title` or the account-switcher button text after success to confirm which actual email address held the thread — it may differ from what the original URL implied, which is worth surfacing to the user since it means a message landed in an inbox they didn't expect.

**Gmail hash-based `#search/<terms>` navigation can also silently not filter** — `goto`/`reload` to a `#search/...` URL sometimes just leaves the full inbox list rendered (stale `tr.zA` rows, no filtering). Fix: `fill "input[aria-label='Search mail']" "<terms>"` then `press Enter`, wait ~2-3s, then read `tr.zA` rows. On this machine the operator's Edge (attach `--cdp=http://localhost:9222`) had `u/1` = bruce.markham@gmail.com (u/0 illuminus86, u/2 brucificus, u/3→u/0). A `reload` on Gmail can raise a `beforeunload` modal — clear it with `dialog-accept`/`dialog-dismiss` before the next eval.

Related: [[brave-cdp-9222-attach]]
