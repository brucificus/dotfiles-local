---
name: gm-careers-happydance-board
description: General Motors careers site is Happydance (Cielo), NOT Workday; search-careers.gm.com/en/jobs/jr-<id>/<slug>/
metadata:
  type: reference
---

General Motors (GM) job board = **search-careers.gm.com** (mirror: careers.gm.com), "Powered by Happydance" (Cielo career-site product). **Not Workday** — `generalmotors.wd5.myworkdayjobs.com` tenant name resolves but every site-ID guess 404s; do not chase a CXS API.

- Job detail URL: `https://search-careers.gm.com/en/jobs/jr-2026XXXXX/<slug>/`
- Req ID format shown on page: `JR-2026XXXXX` (matches the `jr-` in the URL).
- Listing search: `https://search-careers.gm.com/en/jobs/?search=<terms>` — IS relevance-ranked (best match is card #1) even though the "N matching" counter stays huge (~600-800, basically the whole board). Judge by rank/title, not the count.
- Liveness signals on detail page: `Apply Now` button present + no "no longer accepting / filled / expired" text. Page shows `Posted <Mon DD YYYY>` and `Job Requisition`. No ld+json on the page.
- Renders fine in the attached (Brave/Edge) session via `eval` on `document.body.innerText`; WebFetch works for the detail page but the `?search=` listing via WebFetch does NOT apply the filter (returns generic first page).
- GM stack skews Java/Spring, Python, Go, React, embedded C/C++, Azure/AWS/K8s. No dedicated C#/.NET SWE roles seen (C# only appears inside polyglot DevEx JD lists). Many eng roles are Markham, Ontario (Canada).
- GM DevEx / Developer Experience team (as of 2026-08): paired postings JR-202610566 (Staff SWE – Developer Experience) and JR-202610217 (Principal SWE – Developer Experience), both posted May 13 2026, Austin TX / Warren MI, "no immigration sponsorship". Staff page now reads hybrid 3 days/wk T-W-Th; Principal page still reads "remote US or hybrid". Indeed jk 5494726b0070fd57 = the Staff role.
