---
name: linkedin-full-description-no-expand-needed
description: document.body.innerText on a LinkedIn /jobs/view/ page captures the complete "About the job" text in one eval call, no need to click a "show more" expandable-text-button first
metadata:
  type: reference
---

Superseded refinement to [[linkedin-jobview-extraction]]: that memory says to click the
expandable-text-button before eval'ing #JobDetails_AboutTheJob_<id>. In practice a single
`playwright-cli --raw eval "document.body.innerText"` on the whole page already returns the
full untruncated job description (all sections: Company Overview, Position Overview,
Responsibilities, Qualifications, Compensation, closing EEO statement) even though the DOM
shows a collapsed "… more" affordance elsewhere on the page. innerText pulls the full text
node content regardless of CSS-collapsed height, so the click step can usually be skipped —
just eval body.innerText once and parse out the "About the job" section from the dump. Still
watch for a genuinely truncated case (compare where the description text ends vs where
"Benefits found in job post" / "Set alert for similar jobs" boilerplate begins) before trusting
it's complete.

Confirmed genuinely-truncated example (2026-08-18, Accenture Federal Services Sr SWE,
linkedin.com/jobs/view/4337632328): body.innerText's "About the job" section ended mid-sentence
with a trailing "… more" even though it looked complete at a glance. Reliable check: eval
`document.getElementById('JobDetails_AboutTheJob_<jobId>')` (id embeds the numeric job id from
the URL) and see if ITS innerText also ends in "… more" — if so, click the `button` inside that
same container (`container.querySelector('button')`), no need to hunt for expandable-text-button
by class name. Re-eval the container's innerText after the click to confirm the "… more" is gone
before treating the text as complete/verbatim.

Fast decorative-vs-real check (2026-08-18, AlphaSense Staff SWE, linkedin.com/jobs/view/4423320145):
before clicking anything, grep the button's outerHTML out of `document.body.innerHTML` (search
around the last ~15 words of the visible description). If that `data-testid="expandable-text-button"`
button carries `aria-hidden="true"` and `pointer-events: none` in its inline style, it's a dead/decorative
leftover — the text already displayed (and captured by body.innerText) is the full description,
skip clicking entirely. Only bother clicking when the button is NOT aria-hidden/pointer-events:none
AND the JobDetails_AboutTheJob_<id> container's own innerText independently ends in "… more".

Second confirmed instance (2026-08-18, Bitmovin Senior Software Engineer,
linkedin.com/jobs/view/4448859590): body.innerText's job description also ended in "… more"
right before the "Featured benefits" boilerplate. This time three separate "… more" buttons
existed on the page (job description, plus two AI-generated "Company focus areas" / hiring-trend
insight panels lower down) — clicking all `button` elements whose exact trimmed textContent is
"… more" in one eval, then re-evaling body.innerText, expanded all of them safely and cleanly
removed the truncation marker after the job description's closing sentence. Treat "does the
Featured benefits / Set alert boilerplate immediately follow a real closing sentence, or does it
follow a dangling '… more'" as the go/no-go check every time — don't assume either outcome.
