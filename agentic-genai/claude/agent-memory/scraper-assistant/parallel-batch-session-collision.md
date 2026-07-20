---
name: parallel-batch-session-collision
description: When multiple parallel scraper-assistant batches attach to the same CDP endpoint, using the default playwright-cli session name causes random disconnects/tab-loss from cross-batch collisions.
metadata:
  type: feedback
---

When running as one of several parallel batches all hitting the same Edge instance via `--cdp=http://localhost:9222`, do NOT use the unnamed/default playwright-cli session (`playwright-cli attach ...` with no `-s=` flag). Symptoms observed: `playwright-cli --raw eval ...` or `tab-list` intermittently fails with `The browser 'default' is not open, please run open first`, or lands on the wrong tab (`about:blank` or another batch's page), even seconds after a successful `attach`/`goto`.

**Why:** `playwright-cli list` revealed many concurrently open named sessions (e.g. `batchB`, `batchC`, `batchL`, `batchN`, `batchP`, `batchS`, `batchV1`, `batch_seclisting`, `default`, `peraton1`, `scrape`) all attached to the same CDP endpoint — other parallel agents are also using generic names like `default`, and whichever one last called `attach`/`close` on that session name steals or tears down the shared state out from under you.

**How to apply:** As soon as you know you're one of several parallel batches (task says "N parallel batches"), immediately pick a unique session name for every playwright-cli command, e.g. `playwright-cli -s=batchFEI attach --cdp=http://localhost:9222`, and use that same `-s=<name>` flag on every subsequent command (`tab-new`, `goto`, `eval`, `close`, etc.) for the rest of the session. Never fall back to the bare/default session name mid-task. See also [[edge-attach-remote-debugging]].
