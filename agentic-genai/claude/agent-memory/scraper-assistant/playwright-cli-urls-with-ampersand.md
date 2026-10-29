---
name: playwright-cli-urls-with-ampersand
description: How to pass long URLs with & to playwright-cli on this Windows box without killing the CDP session
metadata:
  type: feedback
---

Passing a URL containing `&` to `playwright-cli goto` on this machine:

- Use the **Bash tool** (Git Bash / POSIX sh) with the URL in **single quotes**: `playwright-cli -s=<sess> goto 'https://...&a=1&b=2'`. Works cleanly.
- Do NOT use PowerShell's `--%` stop-parsing token with playwright-cli. On 2026-08-29 a `playwright-cli --% goto "...&..."` call was not just truncated — it left playwright-cli printing its help text AND the attached CDP session (`scrape9222`) was gone afterward, forcing a re-attach. Re-attaching is cheap but it re-enumerates tabs and a scratch tab I had opened came back at a different index.
- After a forced re-attach, always `tab-list` again and identify your scratch tab by its URL/title before closing — indices shift.

**Why:** lost ~4 tool calls recovering a dead session mid-task.
**How to apply:** any goto with query params — reach for the Bash tool + single quotes first; never `--%`.

Related: [[parallel-batch-session-collision]], [[playwright-close-vs-detach-attached-session]]
