---
name: kldiscovery-oracle-orc-board
description: KLDiscovery careers ATS is Oracle Recruiting Cloud (Fusion HCM); hit its public REST API for liveness + full JD instead of the JS-blank SPA
metadata:
  type: reference
---

KLDiscovery (eDiscovery / legal tech) careers page is www.kldiscovery.com/about/careers.
It links out to Oracle Recruiting Cloud (Fusion HCM Candidate Experience) on host
`ekug.fa.us6.oraclecloud.com`, sites `CX_2001` and `CX_3001` (`CX_1001` is talent-community join).
US corporate/engineering roles live under **CX_2001**.

The `/hcmUI/CandidateExperience/...` SPA renders a blank body in an attached CDP session
(CSP / JS blocked — see [[attached-session-csp-blocking]]). Use the REST API directly instead:

- List: `GET https://ekug.fa.us6.oraclecloud.com/hcmRestApi/resources/latest/recruitingCEJobRequisitions?onlyData=true&expand=requisitionList.secondaryLocations,flexFieldsFacet.values&finder=findReqs;siteNumber=CX_2001,limit=200,sortBy=POSTING_DATES_DESC`
  -> `items[0].requisitionList[]` with `Title`, `PrimaryLocation`, `Id`, `PostedDate`. A role absent from this list = CLOSED.
- Detail: `GET .../recruitingCEJobRequisitionDetails?expand=all&onlyData=true&finder=ById;Id="<Id>",siteNumber=CX_2001`
  -> `items[0]` with `ExternalDescriptionStr` / `ExternalQualificationsStr` / `ExternalResponsibilitiesStr` (HTML), `ExternalPostedStartDate`, `ExternalPostedEndDate`, `PrimaryLocation`.
- No auth needed; curl works, WebFetch works. URL-encode the `;` `,` `"` in the finder param.

Internal req Id is a bare 4-digit number (e.g. 1973). This does NOT match the LinkedIn job ID.
