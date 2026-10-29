---
name: onecall-avature-board
description: One Call Care Management (onecallcm.com) careers ATS is Avature — slug onecall.avature.net, SearchJobs listing + JobDetail/<slug>/<id> pages, plain HTML works in attached session
metadata:
  type: reference
---

One Call / One Call Care Management (workers'-comp care coordination, remote-first, HQ Jacksonville FL).

- onecallcm.com/careers 404s. Real path: onecallcm.com/about/one-call-careers/ -> "View Openings" -> **https://onecall.avature.net/careers** (ATS = **Avature**, NOT Infor/Oracle).
- Listing: `https://onecall.avature.net/careers/SearchJobs/?jobRecordsPerPage=6&jobOffset=N` (N = 0,6,12,18…). `jobRecordsPerPage` override to a bigger number is ignored — must paginate by offset of 6.
- Detail page: `https://onecall.avature.net/careers/JobDetail/<Slug>/<JobID>` — renders as plain server HTML, body.innerText carries full JD + a "General information" block with Location / Function / Business Unit / Salary Range Min - Max (USD) / Date (posted, DD-Mon-YYYY) / Job ID. No CSP/SPA problem in the operator's attached session.
- Apply link: `<a>` to `/careers/ApplicationMethods?jobId=<JobID>`. Present = live/accepting. Board-wide banner "This job posting will remain open ... until the position is filled and/or cancelled" appears on every page — not a per-job signal.
- One Call posts distinct engineering levels as separate reqs with distinct salary bands: Software Engineer II & Full Stack Engineer share $102,069–$163,311; Software Engineer Lead $120,442–$192,707; Senior/Principal Engineer & Senior Manager Engineering share $142,121–$227,394.
- LinkedIn "Promoted by hirer · Responses managed off LinkedIn" for One Call = applications actually routed to the Avature board; LinkedIn copy goes "No longer accepting applications" while the Avature req can still be open.
