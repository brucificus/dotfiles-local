---
name: google-messages-web-archive
description: How to archive threads and enumerate the Archived folder in Google Messages web via playwright-cli, incl. a lazy-load limitation
metadata:
  type: reference
---

Google Messages web (messages.google.com/web/conversations), driven via playwright-cli attached over CDP.

**Conversation list / permalinks**
- List is `[role=listbox]`; rows are `<a role="option" data-e2e-conversation href="/web/conversations/<id>">`. Permalink = `https://messages.google.com` + that href. No need to open threads to get IDs.
- List is virtualized: loop `listbox.scrollTop += ~900` with ~180ms waits to render all rows.

**Archiving one thread without opening it**
- Hover the row's `.avatar-container` -> reveals `button[data-e2e-conversation-list-item-menu]` ("Options for <name>").
- Click it -> menu with `[data-e2e-conversation-menu-archive]` ("Archive"), `[data-e2e-conversation-menu-block]`, `[data-e2e-conversation-delete]`, `[data-e2e-conversation-menu-mute]`.
- Click `[data-e2e-conversation-menu-archive]`. Verify with `!document.querySelector("a[href='/web/conversations/<id>']")` and the listbox option count dropping by 1.
- Right-click / native context menu does NOT work here.
- Menu sometimes fails to open on first click (timing) — retry with explicit scrollIntoView + longer sleeps + assert menu present before clicking archive.

**Opening the Archived folder**
- Click `button[data-e2e-branded-header-menu-button]` ("Main menu") to open the left drawer. Drawer nav items are `[data-e2e-nav-item]` with text: Call, Voicemail, Archived, Spam & blocked, Unpair, Help, Send feedback.
- Click the one whose `innerText.trim()==='Archived'` via an eval `.click()` (a `:has-text()` selector click can toggle the drawer shut without navigating).
- Archived view opens as a `mat-dialog-container` (NOT a route change; URL stays /web/conversations). Rows are `div[data-e2e-archived-conversation]`, each with an `[data-e2e-unarchive-button]`. No href on these rows — identify by visible text only. Close with the dialog's "Done" button.

**LIMITATION (hit 2026-08-29):** the Archived dialog renders only its first page (~25 newest threads, date-desc) and then shows a permanent loading spinner. Its infinite-scroll next page would not fetch in the operator's attached browser (console full of `ERR_BLOCKED_BY_CLIENT` from an ad/tracker-blocker extension — same family of interference as [[attached-session-csp-blocking]]). Synthetic scrollTop, wheel events, mousewheel, scrollIntoView on the last row — none triggered more loading. So you cannot fully enumerate a large Archived folder from an attached session. Fall back to: (a) per-item gone:true verification at archive time, (b) full inbox re-enumeration + count math (inbox == original_total - archived) to prove completeness.
