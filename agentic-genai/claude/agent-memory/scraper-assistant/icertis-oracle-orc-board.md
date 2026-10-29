---
name: icertis-oracle-orc-board
description: Icertis careers ATS is Oracle Recruiting Cloud (Fusion HCM); use hcmRestApi JSON, SPA renders blank in attached session
metadata:
  type: reference
---

Icertis (AI contract intelligence / CLM) careers site links out from icertis.com/company/careers to Oracle Recruiting Cloud.

- Tenant host: `iaaviz.fa.ocs.oraclecloud.com`
- Candidate site path: `/hcmUI/CandidateExperience/en/sites/Jobs-at-Icertis/`
- siteNumber: `CX_1`
- SPA job list/detail render BLANK (empty body) in the operator's attached CDP browser (CSP), same failure mode as [[kldiscovery-oracle-orc-board]] and [[attached-session-csp-blocking]]. Use the REST API via `page.eval(fetch(...))` instead — the API is same-origin and works fine from the blank SPA page.
- List: `fetch('/hcmRestApi/resources/latest/recruitingCEJobRequisitions?onlyData=true&expand=requisitionList.secondaryLocations&finder=findReqs;siteNumber=CX_1,keyword=<kw>,sortBy=POSTING_DATES_DESC,limit=25')` -> items[0].requisitionList[]. Each has Id, Title, PrimaryLocation, PrimaryLocationCountry, PostedDate, WorkplaceTypeCode.
- Detail: `fetch('/hcmRestApi/resources/latest/recruitingCEJobRequisitionDetails?expand=all&onlyData=true&finder=ById;Id=%22<Id>%22,siteNumber=CX_1')` -> items[0]. Full JD split across `ExternalDescriptionStr` (intro), `ExternalResponsibilitiesStr`, `ExternalQualificationsStr` (comp + citizenship clause live here). `ExternalPostedEndDate: null` = still open/posted.
- Public job URL: `https://iaaviz.fa.ocs.oraclecloud.com/hcmUI/CandidateExperience/en/sites/Jobs-at-Icertis/job/<Id>`
- Aug 2026: the VA/Public-Sector "Lead Software Engineer" req is Id 7234 (loc "VA, United States", hybrid, posted 2026-07-06). Icertis also runs non-PublicSector "Lead Software Engineer" reqs in NY (7473) and India data-eng (7604).
