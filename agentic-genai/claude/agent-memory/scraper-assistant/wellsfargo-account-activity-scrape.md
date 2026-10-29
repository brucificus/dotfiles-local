---
name: wellsfargo-account-activity-scrape
description: Wells Fargo Online Account Detail transaction list scraping - DOM selectors, 300-row pages, progressive render trap, expand-row details, "View receipt" leaves site
metadata:
  type: reference
---

Wells Fargo Online (connect.secure.wellsfargo.com, hash `#/accounts/home/accountdetails`), learned 2026-09-25 on a CDP-attached Chrome at localhost:9222.

- The account holder banner said "Welcome, DANIEL". The operator's legal first name is Daniel, and he goes by Bruce (Bruce Markham). This is not a different person.
- Transaction rows: `tr[class*="transaction-row"]`. The td cells after the expander are Date | Description | Deposits/Credits | Withdrawals/Debits | Ending Daily Balance. The balance appears only on the first-listed (last-posted) row of each day.
- Page size is about 300 rows. **Trap:** right after (re)load the page renders progressively. I saw 204 rows first, then 300. Poll until the row count is stable before extracting or clicking Next. Otherwise a Next click can be swallowed and you re-read page 1.
- Pagination: `button[class*="TransactionPages__nav-link"]` with text First/Previous/Next. A disabled button has `TransactionPages__disabled` in its class. There are also HotTaskPaddle Next/Previous buttons (a carousel), so don't confuse them.
- Row details: `button[data-testid="transaction-expand-button"]`, whose aria-controls points to `transaction-N`. It is read-only. It shows Category, plus for card purchases Merchant Name/Address/Transaction Method. It also contains "Dispute this transaction", so don't click inside it. The first expand sometimes needs ~1-2s before the detail element exists.
- "View receipt" (Apple rows) opens a "Leaving Wells Fargo" interstitial. Press Cancel and don't follow it.
- The session can expire mid-task, and the operator re-logs in a NEW tab (tab index shifts). Re-run tab-list and match by title "Account Detail - Wells Fargo".
- Run playwright-cli from the default cwd. A `cd` into scratchpad made the named session "not open" (sessions are cwd-scoped). Redirect output to absolute paths instead.
