---
name: gem-jobs-graphql-board
description: Gem (jobs.gem.com) careers board — public GraphQL API for job list + detail, no auth, WebFetch-friendly
metadata:
  type: reference
---

Some employers host careers on **Gem** at `https://jobs.gem.com/<slug>` (e.g. Function Health = slug `function-health`). The page is a React SPA (WebFetch returns only the `<title>`), but there is an unauthenticated public GraphQL endpoint:

- Endpoint: `POST https://jobs.gem.com/api/public/graphql` (also `/api/public/graphql/batch`)
- Slug is the first path segment of the board URL; it is also the GraphQL `boardId` variable.

**List all open postings:**
```
query JobBoardList($boardId: String!) {
  oatsExternalJobPostings(boardId: $boardId) {
    jobPostings { extId title locations { name isRemote } job { locationType employmentType requisitionId teamDisplayName department { name } } }
  }
}
```
`extId` (opaque string) is the per-posting key for the detail query. `requisitionId` is the human req code (e.g. `ENG-26-29`); one posting can bundle several reqs (`ENG-26-50/51/56`).

**Posting detail (JD, comp, dates):**
```
query D($boardId: String!, $extId: String!) {
  oatsExternalJobPosting(boardId: $boardId, extId: $extId) {
    title descriptionHtml compensationHtml startDateTs firstPublishedTsSec
    locations { name isRemote } job { requisitionId department { name } }
  }
}
```
- `firstPublishedTsSec` = unix seconds of first publish (multiply by 1000 for JS Date).
- `compensationHtml` is often `null` (many Gem employers omit pay entirely).
- A posting appearing in the list == live/listed. Removed posting -> detail returns null and SPA shows "Job not found".
- Public job URL: `https://jobs.gem.com/<slug>/<extId>`.

Liveness of a carded LinkedIn role: match by exact JD text (Company Overview / Key Responsibilities paragraphs are copied verbatim between LinkedIn and the Gem posting).

Function Health specifics: slug `function-health`, board id `05427c82-241d-4ea9-ab4d-0190fd1d515f`. Nearly every posting is tagged `US - Remote`. Ezra (imaging) sub-org reqs use `SCANS-*` prefixes and are the only ones on a C#/.NET/Azure/SQL Server stack; core Engineering + Data are Python/Go/Rust.
