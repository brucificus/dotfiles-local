---
name: brave-cdp-9222-attach
description: Attaching to operator's Brave browser via CDP port 9222 works reliably when Edge attach fails; use `document.querySelector('main').innerText` for LinkedIn job pages instead of clicking individual "more" buttons.
metadata:
  type: user
---

Operator's visible browser is sometimes Brave, not Edge/msedge. When `attach --cdp=msedge` fails or the operator says "try Brave", use:

`playwright-cli attach --cdp=http://localhost:9222`

This succeeded and exposed all open tabs (mixed browsing history) — use `tab-new <url>` to open the target page in a fresh tab rather than navigating an existing one, so the operator's other tabs are undisturbed.

For LinkedIn job-view pages specifically: rather than hunting for `#JobDetails_AboutTheJob_<id>` and clicking individual "…more" expandable-text buttons (see [[linkedin-jobview-extraction]]), a single `document.querySelector('main').innerText` eval after page load captured the ENTIRE rendered page content in one shot — full job description, qualifications, salary range, company "About" section, and even LinkedIn's AI-generated company-insight panels (headcount trends, competitors, etc.) — without needing any clicks. This is likely because the description text wasn't actually truncated/collapsed in this render, or `innerText` picks up collapsed content anyway. Try this first as a cheaper alternative before clicking "more" buttons.

Check "no longer accepting applications" via a targeted eval (`document.body.innerText.includes(...)`) rather than reading full body text just for that check — cheaper and no snapshot noise.

**Update 2026-08-05 — spurious 404s on port 9222, fixed only by full browser restart:** Seen a case where 9222 was open (confirmed via `netstat -ano | findstr :9222` + `Get-CimInstance Win32_Process` showing brave.exe owned it) but `attach --cdp=http://localhost:9222` failed with a genuine `404 Not Found` on `/json/version`, `/json`, `/json/list`, `/` — real Chromium-style headers, not a wrong-port guess. A separate `msedge.exe` process also had `--remote-debugging-port=9222` on its command line but was a red herring — it didn't actually hold the port. Toggling a debugging checkbox in the browser did NOT fix the 404s. **Fully quitting and relaunching Brave did** — after that, attach connected immediately. If 9222 answers with clean 404s instead of connection-refused, ask for a full browser restart rather than guessing more URLs/ports.

**Gmail account slot:** bruce.markham@gmail.com is Google account slot `u/1` in Bruce's Brave profile (`u/0` is a different, unrelated account). Use `https://mail.google.com/mail/u/1/#...` for his job-hunt inbox.

**Gmail deep-link by message id often fails silently:** Navigating straight to a provided `#inbox/<hex-id>` or `#all/<hex-id>` Gmail permalink did not open the target thread — it silently fell back to the inbox or an unrelated filtered view, no error thrown. Reliable workaround: navigate to `#search/<distinctive keywords from subject, e.g. company + role>`, then in the results DOM find the `<tr>` whose `innerText` includes those keywords and `.click()` it via `playwright-cli eval`. This reliably opens the right thread.

**Indeed job-alert emails wrap the listing link in a `cts.indeed.com/v3/...` tracked-redirect URL**, link text "View job" — search all `<a>` tags via eval and filter by `innerText`/`href` rather than trusting the visual snapshot. Opening that redirect (e.g. in a new tab via `tab-new`) resolves straight to a normal `indeed.com/viewjob?jk=...` page. See [[indeed-scrape-extraction]] for extracting the posting body once there.
