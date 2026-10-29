---
name: reliable-robotics-ashby-board
description: Reliable Robotics careers = Ashby board slug `reliable-robotics` (with hyphen); every req is US export-control / U.S.-person gated
metadata:
  type: reference
---

Reliable Robotics Corporation (autonomous/remotely-piloted aviation, Mountain View CA; careers contact work@reliable.co) uses **Ashby**.

- Board API: `https://api.ashbyhq.com/posting-api/job-board/reliable-robotics?includeCompensation=true` — slug has the hyphen. `reliablerobotics` (no hyphen), Greenhouse, and Lever all 404. See [[ashby-posting-api]] for field semantics.
- reliable.co/careers renders the list client-side and is blank in the operator's attached browser (CSP) — go straight to the API JSON.
- **Every posting** (52/52 when checked 2026-08-30) carries the identical U.S. export-control / U.S.-person clause. Treat export-control gating as a given for this employer, not a per-role flag.
- Ashby exposes only UUID ids, no human-readable req numbers.
- "Remote" often appears as a `secondaryLocations` entry (addressCountry US) on otherwise Mountain-View-primary roles = US-remote-eligible.
- No C#/.NET anywhere on the board (all C/C++, Python, FPGA/HDL, flight SW). The one frontend/UI-ish SWE role is "Displays Software Engineer, C/C++" (remote-piloting/pilot-facing UI team).
