---
name: playwright-cli-tab-close-syntax
description: playwright-cli tab-close / tab-select take a POSITIONAL index arg, not --index=N; passing --index prints usage and silently no-ops (or worse, a later retry closes the wrong tab)
metadata:
  type: reference
---

`playwright-cli --s=<sess> tab-close <index>` and `tab-select <index>` want a **bare
positional** integer: `tab-close 5`, not `tab-close --index=5`. Passing `--index=5`
just dumps the arg-usage blurb and does nothing. Confirmed 2026-08-28.

Cleanup hazards learned the hard way that session:
- After `--index=` no-ops, I retried with positional args against indices I'd computed
  from a *stale* tab list — closed two of the operator's pre-existing tabs by mistake.
  Always re-run `tab-list` immediately before each `tab-close`, and close **highest
  index first** so earlier indices don't shift under you.
- `tab-new` appends at the end; note the exact URLs of any tabs you open so you can
  close those specific ones by matching title/URL, not by remembered index.
- If you do clobber an operator tab, `tab-new <url>` to restore it (a LinkedIn/job tab
  just reloads fresh — fine), then `tab-select 0` (or whatever their original active
  tab was) before `detach`.
- DETACH + RE-ATTACH REORDERS THE TAB LIST. After a fresh `attach` the currently-active
  tab is renumbered to index 0 and everything else shifts. An index you computed before
  detaching is now wrong. Confirmed 2026-08-30: closed the operator's Concorde LinkedIn
  tab this way. Rule: after every `attach`, run a tab-list and match the tab you want by
  URL/title, then close by its *current* index. Better: finish all tab cleanup in ONE
  attached session and don't detach until tabs are back to the original set.

See also [[playwright-close-vs-detach-attached-session]].
