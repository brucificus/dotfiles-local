---
name: playwright-close-vs-detach-attached-session
description: for an attached (CDP) session, always use `detach` not `close` when ending work — close is the wrong verb even though it turned out non-destructive
metadata:
  type: reference
---

For a session created with `attach --cdp=...` (the operator's real, visible browser), end
your work with `playwright-cli -s=<name> detach`, never `close`. `close` is meant for browser
instances playwright itself launched (`open`); on an attached session it's the wrong verb and
its semantics aren't guaranteed.

Empirically on one occasion `close` on an attached session only tore down the local CLI
session/CDP link — re-attaching immediately after showed the operator's browser and all its
other tabs completely intact. But this was verified after the fact, not by design — the API
distinguishes `close` (owns/closes the browser) from `detach` (leaves external browser running)
for a reason. Don't rely on the observed safe behavior; just use `detach` on attached sessions
so you're never gambling with the operator's live browser state (open tabs, unsaved form data,
Gmail compose drafts, etc).
