---
name: edge-attach-remote-debugging
description: playwright-cli attach --cdp=msedge fails with "DevToolsActivePort file not found" unless remote debugging was explicitly enabled in that running Edge instance.
metadata:
  type: feedback
---

`playwright-cli attach --cdp=msedge` cannot connect to Bruce's already-running, already-authenticated Edge window out of the box. It fails with:

```
Could not connect to msedge: DevToolsActivePort file not found at ...\Microsoft\Edge\User Data\DevToolsActivePort.
Make sure msedge is running with remote debugging enabled.
```

**Why:** Edge does not expose a CDP debugging port by default. The flag has to be turned on inside that running browser instance before attach will work — there is no way to retroactively enable it on an already-launched process from outside.

**How to apply:** When starting a session, before assuming connectivity, try `playwright-cli attach --cdp=msedge` (cheap, fast-fail). If it fails with the DevToolsActivePort error, ask Bruce (do NOT try to drive his desktop blindly) to do one of:
1. In the visible Edge window, navigate to `chrome://inspect/#remote-debugging` and check "Allow remote debugging for this browser instance", then retry attach, OR
2. Fully close that Edge instance and relaunch it with `--remote-debugging-port=9222` (or similar), then attach via `--cdp=http://localhost:9222`.

`attach --extension=edge` is NOT a fallback — in practice it looked for the Playwright Extension under the Chrome profile path (`...Google\Chrome\User Data`), not Edge's, and failed with "Extension not found." Don't bother trying it again for Edge without first confirming the extension is actually installed in the Edge profile.

Do not try to fix this yourself by launching a fresh `playwright-cli open --persistent` Edge profile as a workaround — that opens an unauthenticated, separate browser instance, defeating the purpose of using Bruce's already-logged-in session. Always ask Bruce to enable remote debugging on the real window first.

**CONFIRMED WORKING RESOLUTION (2026-06-30):** Bruce uses a personal launcher script that fully closes Edge and relaunches it with `--remote-debugging-port=9222` (confirmed via `Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" | Select CommandLine` showing that flag on the main process). After that relaunch, `attach --cdp=msedge` STILL failed with the same DevToolsActivePort error — that channel-name shortcut apparently doesn't pick up the active port file correctly in this setup. The fix: skip `--cdp=msedge` entirely and instead attach directly to the known port:

```
playwright-cli attach --cdp=http://localhost:9222
```

This worked immediately and exposed all of Bruce's open tabs with full history. **Going forward, when Bruce says he's restarted Edge with his remote-debugging script, go straight to `attach --cdp=http://localhost:9222` — don't waste a round-trip on `--cdp=msedge` first.**

See also [[scraper-assistant-session-start]] for the full startup checklist this fits into.
