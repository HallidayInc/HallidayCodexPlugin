# Evaluation: Payment Lookup

## Input Query

"Can you look up payment pay_abc123 for me?"

## Expected Behavior

1. The `halliday` skill activates based on keyword match or direct invocation
2. Codex identifies this as a payment lookup request
3. Codex reads `reference/payment-lookup-guide.md`
4. Codex checks if the developer has already provided a Halliday API key (from onboarding). If not, asks for one via a structured question.
5. Codex calls `api-fetch.sh` to fetch payment status:
   ```
   <PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <API_KEY> GET /payments "payment_id=pay_abc123"
   ```
6. Codex parses the response and **presents a clear summary first**:
   - Payment ID, status, funded flag
   - Payment type (fiat onramp or crypto swap)
   - Input and output amounts/assets
   - Owner and destination addresses
   - Duration
   - Fee breakdown
7. **Then, based on status:**
   - COMPLETE: extracts transaction hash, calls `GET /chains` to build block explorer link
   - PENDING: shows time remaining until funding deadline, next instruction details
   - FAILED or funded EXPIRED: calls `POST /payments/balances` to check OTW balances, suggests recovery options (retry vs withdraw)
   - WITHDRAWN: shows completion details
   - TAINTED: explains sanctions flag, directs to support
8. If recovery is needed, Codex explains both options (retry and withdraw) with specific steps

## Expected Files Loaded

- `SKILL.md` (via skill activation)
- `reference/payment-lookup-guide.md` (for interpretation guidance)

## Expected API Calls

- `GET /payments?payment_id=pay_abc123` (always)
- `POST /payments/balances` (only if FAILED or funded EXPIRED)
- `GET /chains` (only if COMPLETE, to build explorer link)

## What Should NOT Happen

- Should NOT skip the payment summary and jump straight to diagnosis
- Should NOT fabricate payment data — all information must come from the API response
- Should NOT call endpoints not in the api-fetch.sh allowlist
- Should NOT expose the API key in the output shown to the user
- Should NOT load `reference/integration-checklist.md` — this is a lookup, not a code review
- Should NOT fetch external documentation
- Should NOT attempt to execute recovery actions (withdraw, re-quote) — only explain the steps
- Should NOT call `POST /payments/balances` for COMPLETE or unfunded EXPIRED payments
