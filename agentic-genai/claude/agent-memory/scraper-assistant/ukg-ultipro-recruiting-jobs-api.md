---
name: ukg-ultipro-recruiting-jobs-api
description: UKG Pro / UltiPro Recruiting (recruiting2.ultipro.com/<TENANT>) job-board liveness + listing via LoadSearchResults POST; detail pages need a clean browser
metadata:
  type: reference
---

UKG Pro / UltiPro Recruiting careers boards live at `https://recruiting2.ultipro.com/<TENANT>/JobBoard/<boardGuid>`.
`<TENANT>` e.g. `BAY1006BML` (Baylor Genetics). Hitting `/<TENANT>` 302s to the `/JobBoard/<boardGuid>` canonical URL.

**Listing / liveness (works even from an attached CSP-blocked session — it is a same-origin XHR):**
`POST /<TENANT>/JobBoard/<boardGuid>/JobBoardView/LoadSearchResults`
Content-Type: application/json
body:
```json
{"opportunitySearch":{"Top":200,"Skip":0,"QueryString":"","OrderBy":[],"Filters":[]},
 "matchCriteria":{"PreferredJobs":[],"Educations":[],"LicenseAndCertifications":[],"Skills":[],"WorkExperiences":[],"DegreeTypes":[]}}
```
Returns `{opportunities:[...]}`. Per-item fields: `Id` (GUID), `Title`, `RequisitionNumber` (e.g. `SRSOF002445`), `FullTime`, `JobCategoryName`, `Locations[]` (full address + `LocalizedDescription` like "Headquarters" / "TX - Hybrid"), `PostedDate` (ISO), `BriefDescription` (short summary, NOT full JD), `JobLocationType` (0/1/2 — 1 seen for onsite, 2 for remote/hybrid), `OpportunityType`.
`QueryString` does keyword search across the full JD (so you can probe "SSIS", "ETL", etc. to check if a role exists).
A req present in this response = OPEN. Gone = CLOSED/filled.

**Full JD:** no working JSON detail endpoint found (`/Opportunity/<id>`, `/JobBoardView/LoadOpportunity*`, `/OpportunityDetail/*` all 404). The human page
`/<TENANT>/JobBoard/<boardGuid>/OpportunityDetail?opportunityId=<GUID>` is an Angular SPA that renders blank in the operator's attached Brave/Chrome (extension CSP blocks the app bootstrap — see [[attached-session-csp-blocking]]). Open it in a **clean unattached** `playwright-cli open` chromium and `document.body.innerText` returns the full posting: Posted date, Full-Time, Remote/Onsite/Hybrid, Locations, Description, Qualifications, Skills matrix.

Note: UltiPro boards can carry near-duplicate titles ("Senior Software Engineer" vs "Sr. Software Engineer" vs "Principal Software Engineer") that are genuinely different reqs with different stacks/locations — always diff the JD, don't assume title match = same role. Also seen: an employer silently rewriting one req's JD (years-of-exp bar, whole tech stack) while keeping the same RequisitionNumber, so a cached LinkedIn copy and the live ATS text diverge materially.
