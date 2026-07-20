---
name: linkedin-tab-titles-misleading
description: LinkedIn browser tab titles show the currently-selected/last-clicked job posting's title, not the page's actual content — a tab can be a 156-result search list while its title reads like a single job posting.
metadata:
  type: feedback
---

When listing open tabs (e.g. via `playwright-cli tab-list` or the tab summary in any command's output), do NOT infer what a LinkedIn tab actually contains from its title alone. LinkedIn sets the document title to the currently-selected job card's title + company (e.g. "SIL Sr Full-Stack Developer | Sonepar USA | LinkedIn"), even when the underlying page is a full search-results list (`/jobs/search-results/...`) with 100+ results and that job is just whichever one was last clicked/highlighted.

**Why:** Bruce caught this directly — he pointed out a tab titled like a single Sonepar USA posting was actually his "More jobs for you" search results page with 156 results, and the proscribed-looking title almost caused me to write off the whole tab as a single skip-worthy posting instead of surfacing the dozens of legitimate leads inside it.

**How to apply:** Before judging or reporting on any LinkedIn tab found in a tab list, check the URL pattern, not just the title:
- `linkedin.com/jobs/search-results/...` → it's a results list. Take a real `snapshot` (or scroll through it) to see the actual set of postings before concluding anything from the title.
- `linkedin.com/jobs/view/<id>/...` → it's actually a single posting page; title is reliable there.
This applies generally to any SPA job board, but LinkedIn is the confirmed offender — be suspicious of tab titles on Indeed/Glassdoor/etc. too if something looks off (e.g. title says one company but URL is a generic search/listing path).

See also [[edge-attach-remote-debugging]] for the rest of this session's connection-establishing notes.
