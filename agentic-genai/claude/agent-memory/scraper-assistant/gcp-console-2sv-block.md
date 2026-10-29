---
name: gcp-console-2sv-block
description: Google Cloud console blocks accounts without 2-step verification ("Google Cloud access blocked"); also playwright-cli drops .playwright-cli/ snapshot+console logs into the caller's cwd.
metadata:
  type: reference
---

- console.cloud.google.com for bruce.markham@gmail.com (authuser=1 in the 9222 browser; u/0 is illuminus86@gmail.com) showed "Google Cloud access blocked ... enforce 2-step verification (2SV)" on resource-manager pages (dashboard project selector still renders). Fix is user-only: enable 2SV at myaccount.google.com/security, wait a few minutes, refresh. Treat as NEEDS USER AUTH; check this first before any GCP setup work.
- The 2026-10-12 attach: `--cdp=msedge` timed out after ws connected; `--cdp=http://localhost:9222` (Chrome/155 UA) worked.
- playwright-cli writes `.playwright-cli/` (page-*.yml, console-*.log) into the shell cwd. When the task says "don't edit other files", run commands from the scratchpad dir from the start (rm of the stray dir later was denied by the permission classifier). See [[playwright-cli-tab-close-syntax]].

**GCP console automation tips (2026-10-12, pi-agent-mcp setup):**
- `cd <scratchpad> && playwright-cli ...` in the same Bash call works and keeps .playwright-cli/ out of the project dir.
- API enable: goto /apis/library/<svc>.googleapis.com?authuser=1&project=<id>, JS-click button with innerText 'Enable' (verify "Service name:" first). MCP services exist: gmailmcp, calendarmcp, drivemcp.
- Auth Platform chip-input email fields (contact email, test users): `fill` alone doesn't commit; click field, `type`, press Enter (chip appears). Save: mouse click silently does nothing; eval-focus the dialog button with innerText "Save" then `press Enter` (re-confirmed 2026-10-12, dialog closes, reload shows user).
- Data Access "Manually paste scopes" Add-to-table stays disabled for scopes already listed; instead page the scope table (button.cfc-table-pagination-nav-button-next) and click mat-pseudo-checkbox [aria-label="Select row"] where gridcell[2] text == ".../auth/<scope>", then Update, then Save.
- Client-created dialog shows GOCSPX secret once; any click's auto-snapshot yml captures it — extract via eval straight to file, then sed-redact snapshot yml.
