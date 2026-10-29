---
name: kavaliro-haley-smpl-job-board
description: Kavaliro's own job board is jobs.kavaliro.com (Haley Marketing ".smpl" platform); attached session shows 0 Results, use a clean browser
metadata:
  type: reference
---

Kavaliro (IT staffing firm) job board: https://jobs.kavaliro.com/ — Haley Marketing Group platform (URLs like `/index.smpl?arg=jb_search_results&view=0`, job detail `/jb/<Slugged-Title>-Jobs-in-<City>-<State>/<numericId>`).

- Search: keyword box posts the form; results page title becomes "Kavaliro | <keyword> Jobs". "View All Jobs" button lists everything.
- The visible "0 Results" counter text on the results page is a persistent bug/artifact — ignore it; real cards still render below.
- Attached operator browser (CDP 9222) renders the board with genuinely ZERO job cards (CSP/extension blocks the listing fetch — see [[attached-session-csp-blocking]]). A clean unattached `playwright-cli open` renders the full card list fine.
- Job detail page shows: internal "Job Number" (e.g. 54879), "Posted: MM/DD/YYYY", industry, full JD, Apply button. No dedicated "expired" interstitial observed; a filled req likely just drops from search.
- 2026-08-30: "Specialized Software Developer: IV" (C#/.NET/SQL/SSIS/Azure DevOps, Centennial CO 80112, contract, healthcare end-client) was OPEN both on LinkedIn (jobs/view/4411730538, "Reposted 2 days ago", active Apply) and on Kavaliro's board at /jb/Specialized-Software-Developer-IV-Jobs-in-Centennial-Colorado/14004526 (Job Number 54879).
