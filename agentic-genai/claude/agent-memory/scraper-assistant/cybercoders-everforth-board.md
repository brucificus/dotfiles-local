---
name: cybercoders-everforth-board
description: CyberCoders (now Everforth CyberCoders) staffing job board liveness check — self-hosted SPA, CSP-blocked in attached session, how to resolve a req by JobID
metadata:
  type: reference
---

CyberCoders is a staffing agency (rebranded "Everforth CyberCoders", NYSE: EFOR). Their public board at cybercoders.com is a self-hosted Vite/React SPA.

**Attached session is CSP-blocked**: the operator's browser extension (id `jjhefcfhmnkfeepcpnilbbkaadhngkbi`) injects a CSP with `script-src-elem 'none'` that blocks `/assets/index.*.js`, so `document.body.innerText` is empty. Use a clean unattached browser (`playwright-cli -s=clean open --browser=chrome`).

**Resolve a specific req by JobID**: JD text shows `JobID: linkedin : NNG-1990136L595`. The numeric middle chunk (`1990136`) is the job id. `https://www.cybercoders.com/principal-engineer-job-<num>` redirects to `https://www.cybercoders.com/job-detail/<num>`. A dead req renders "This Job is No Longer Available", no Job ID value, "last updated on Invalid date", no Apply button. A live req shows an "Apply Now" button + real posted date + ld+json JobPosting.

**Search**: URL query params (`/search/?searchterms=...&searchlocation=...`) do NOT filter the SPA list — it renders a stale 3900+ result dump. Instead fill the two visible inputs ("Search job title or keyword" + "Enter location or remote") and press Enter; that navigates to `/search/<terms>?locationKeyword=...&location=<lat,lng>&...` which filters correctly. Search terms with punctuation (".NET", "C#") return "did not match any of our open jobs" — use plain words. Each result card carries an inline ld+json JobPosting with full description.
