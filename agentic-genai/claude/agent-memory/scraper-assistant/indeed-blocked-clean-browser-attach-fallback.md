---
name: indeed-blocked-clean-browser-attach-fallback
description: Indeed viewjob 403/Blocked from curl AND unattached playwright; attached browser (9222) tab-new works; innerText non-ASCII gets mangled by CLI
metadata:
  type: reference
---

Indeed cts.indeed.com -> rc/clk -> 403 via curl; unattached playwright viewjob = "Blocked - Indeed.com". Attached browser (`attach --cdp=http://localhost:9222`, then `tab-new <viewjob?jk=>`) renders fine; close own tab by index and `detach`.
- Use `--raw eval` and JSON.stringify(...) of document.body.innerText; #jobDescriptionText may be absent, so slice from "The application window"/"Full job description" to "Report job".
- playwright-cli stdout mangles non-ASCII (curly quote -> U+FFFD). In JS replace `[^\x00-\x7f]` with `<<U{hex}>>` markers, decode in Python (backslash escapes get eaten).
- Liveness: `"isJobExpired":false` in outerHTML + "Apply on company site".
- Cisco posts same title ("Senior Software Engineer (Remote)") under many LinkedIn IDs/locations with identical JD; LinkedIn guest API (/jobs-guest/.../jobPosting/<id>) works for Cisco without auth and shows "application window is expected to close on" date.
