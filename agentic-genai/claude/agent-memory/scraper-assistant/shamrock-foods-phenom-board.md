---
name: shamrock-foods-phenom-board
description: Shamrock Foods careers ATS is Phenom People at jobs.shamrockfoods.com; how to read liveness/JD and a WebFetch false-"filled" gotcha
metadata:
  type: reference
---

Shamrock Foods Company careers site = Phenom People CMS at `https://jobs.shamrockfoods.com/us/en`.
Job URL pattern: `/us/en/job/<REQID>/<Slug>` e.g. `SENIO011461/Senior-Software-Engineer-NET`.
Req ID (their "Job Id") is the alphanumeric in the URL (SENIO011461); a separate 32-hex GUID also exists internally.

Liveness / JD extraction:
- Full JD is in a `script[type="application/ld+json"]` JobPosting blob (HTML-entity-encoded description), and also in body.innerText once the SPA renders. `datePosted` present; often NO `validThrough` / `baseSalary` in the ld+json even when the visible JD states a salary.
- Phenom updates `datePosted` on refresh — don't trust it as original post date.
- A live/open req renders an active "Apply Now" button and no closed banner. A filled req shows "The position you are trying to apply for has been filled." (same 410-style pattern as [[serco-careers-phenom-site]] / [[bnsf-careers-phenom-repost]]).

GOTCHA: WebFetch on a Phenom job URL can return a FALSE "position has been filled" for a job that is actually OPEN (confirmed 2026-08-28 on SENIO011461 — WebFetch said filled, live unattached browser showed Apply Now + full JD). Always corroborate a WebFetch "filled" with a real browser render before calling it CLOSED.

Attached CDP session (port 9222) renders jobs.shamrockfoods.com body as EMPTY (CSP/extension block, per [[attached-session-csp-blocking]]) but ld+json script tags are still readable via eval. For visible-DOM confirmation use an unattached `playwright-cli -s=<name> open` browser (plain chromium channel; `--browser=chrome` not installed on this machine).
