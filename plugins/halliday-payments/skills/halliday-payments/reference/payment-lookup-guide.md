# Payment Lookup Guide

Use this guide to look up a Halliday payment by ID, interpret its state, and provide diagnosis when applicable.

## Prerequisites

To look up a payment, you need:
- **Public API key** — the developer's Halliday public API key (`pk_...`). They may have already provided this during onboarding.
- **Payment ID** — UUID string (e.g. `41b16a6f-704e-44ba-9964-2b66df8a73e8`)
- **Owner address** — needed only for `/payments/history` lookups, not for single payment status

## API Calls

Use `api-fetch.sh` for all API calls:

```bash
# Get payment status
<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <API_KEY> GET /payments "payment_id=<PAYMENT_ID>"

# Check OTW balances (for recovery diagnosis)
<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <API_KEY> POST /payments/balances "" '{"payment_id":"<PAYMENT_ID>"}'

# Get chain info (for block explorer links)
<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <API_KEY> GET /chains

# Get payment history for an owner
<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <API_KEY> GET /payments/history "owner_address=<OWNER_ADDRESS>&limit=10"
```

The response includes the JSON body followed by the HTTP status code on the last line. Parse accordingly.

## Payment Summary

**Always present a clear summary first**, before any diagnosis. Extract these fields from the `GET /payments` response:

| Field | Source |
|-------|--------|
| Payment ID | `payment_id` |
| Status | `status` (PENDING, UNCONFIRMED, COMPLETE, FAILED, EXPIRED, WITHDRAWN, TAINTED) |
| Funded | `funded` (boolean) |
| Payment type | Fiat onramp if `quote_request.request.fixed_input_amount.asset` is a fiat code like `usd` or `eur`. Crypto swap if it's a token like `avalanche:0x`. |
| Input | `quote_request.request.fixed_input_amount.asset` + `quote_request.request.fixed_input_amount.amount` |
| Output asset | `quote_request.request.output_asset` |
| Quoted output amount | `quoted.output_amount.asset` + `quoted.output_amount.amount` |
| Fulfilled output amount | `fulfilled.output_amount.asset` + `fulfilled.output_amount.amount` (if available) |
| Onramp provider | `quoted.onramp` (if applicable, e.g. "stripe", "moonpay", "coinbase") |
| Payment method | `quoted.onramp_method` (if applicable, e.g. "CREDIT_CARD", "ACH") |
| Owner address | `owner_address` |
| Destination address | `destination_address` |
| Created | `created_at` |
| Completed | `completed_at` (if COMPLETE) |
| Duration | `completed_at - created_at` (or current time - `created_at` if not complete) |
| Funding deadline | `initiate_fund_by` |
| Fees | `quoted.fees.total_fees` (`quoted.fees.conversion_fees` conversion + `quoted.fees.network_fees` network + `quoted.fees.business_fees` business) in `quoted.fees.currency_symbol` |

**Example summary output:**

```
Payment: 41b16a6f-704e-44ba-9964-2b66df8a73e8
Status: COMPLETE
Type: Fiat onramp (Stripe, credit card)
Input: 100 USD → Output: 96.11 USDC on Base
Owner: 0xowner...
Destination: 0xdest...
Duration: 2m 12s (created 2025-10-28T19:30:12Z → completed 2025-10-28T19:32:24Z)
Fees: $3.91 total ($3.91 conversion, $0.00 network, $0.00 business)
Transaction: 0xabc123... (https://basescan.org/tx/0xabc123...)
```

## Status Interpretation

### COMPLETE
The payment succeeded. All workflow steps executed onchain.

**What to show:**
- Fulfilled output amount (may differ slightly from quoted due to real-time pricing)
- Final transaction hash — extract from `fulfilled.route`:
  ```
  fulfilled.route → filter type === "ONCHAIN_STEP" → flatMap net_effect.produce → find account === "DEST" and tx_id exists
  ```
- Block explorer link: call `GET /chains` to get the explorer URL for the output chain, then format as `${explorer}tx/${tx_hash}`

### PENDING
The payment is confirmed but not yet funded, or is funded and executing.

**What to show:**
- `funded` flag: if `false`, the OTW is waiting for funding
- `initiate_fund_by`: deadline to fund the payment
- Time remaining until expiry
- `next_instruction` details:
  - `type: "ONRAMP"` — waiting for user to complete fiat checkout via `funding_page_url`
  - `type: "TRANSFER_IN"` — waiting for token transfer to `deposit_address` on `deposit_chain`
- If `funded: true`, the payment is actively executing its workflow steps

### UNCONFIRMED
The payment requires owner verification before it can proceed to PENDING.

**What to show:**
- The `next_instruction` will have `type: "USER_VERIFY"` with payloads to sign
- The user must sign verification payloads and submit them back to `POST /payments/confirm`
- If the user abandons, the payment is not persisted and a new quote is needed

### FAILED
A workflow step failed during execution.

**What to show:**
- Which route step failed (check `fulfilled.route` for steps with non-COMPLETE status)
- The `next_instruction` may contain an `ERROR_WITHDRAW_OR_ROLLOVER` instruction with an error message
- **Trigger balance check and recovery diagnosis** (see Recovery Diagnosis below)

### EXPIRED
The payment was not funded before the `initiate_fund_by` deadline.

**What to show:**
- Whether the payment was funded (`funded` flag):
  - `funded: false` — safe to abandon. The user can start a new payment.
  - `funded: true` — funds are stuck in the OTW. **Trigger balance check and recovery diagnosis.**
- The `initiate_fund_by` timestamp and how long ago it expired

### WITHDRAWN
Funds were successfully withdrawn from the OTW.

**What to show:**
- The withdrawal completed. No further action needed.
- If there's a `parent_payment_id`, this payment was retried from a previous failed payment.

### TAINTED
An onchain address associated with the payment was flagged by sanctions screening.

**What to show:**
- This payment cannot be completed, retried, or withdrawn.
- The user should contact support@halliday.xyz for assistance.

## Recovery Diagnosis

When a payment is FAILED or funded-EXPIRED, check OTW balances to determine recovery options.

### Step 1: Check balances

Call `POST /payments/balances` with the payment ID.

The response contains a `balance_results` array. Each entry has:
- `address` — the OTW address
- `token` — the token held (format: `chain:address`)
- `account` — account type (`INTENT` or `SPW`)
- `value` — either `{ kind: "amount", amount: "50.0", withdrawal_fee: "0.5" }` or `{ kind: "error" }`

### Step 2: Interpret balances

- **Skip entries with `value.kind === "error"`** — these indicate a balance lookup failure
- **Check `value.amount`** — if greater than zero, the OTW has recoverable funds
- **Net amount** = `amount - withdrawal_fee` (display this to the user as the estimated recovery)
- **Use the full `amount`** (not net) when calling the withdraw endpoint

### Step 3: Present recovery options

If recoverable funds exist, the developer has two options:

**Option A: Retry the payment**
1. Get new quotes: `POST /payments/quotes` with `parent_payment_id` set to the failed payment's ID
2. User selects a quote and it's confirmed via `POST /payments/confirm`
3. Withdraw from old OTW to new OTW: `POST /payments/withdraw` with `recipient_address` as the new payment's deposit address
4. Sign the withdrawal authorization based on `signature_type` (eip712 or eip191)
5. Confirm: `POST /payments/withdraw/confirm`

**Option B: Withdraw to owner wallet**
1. `POST /payments/withdraw` with `recipient_address` as the owner's wallet address
2. Sign the withdrawal authorization
3. `POST /payments/withdraw/confirm`

**Alternative:** Payments can also be recovered via the web UI at `https://app.halliday.xyz/funding/${payment_id}` by connecting the owner wallet.

## Route Analysis

The `fulfilled.route` array shows the actual execution path:

- **USER_FUND** — the initial deposit step (user or onramp sends tokens to OTW)
- **ONCHAIN_STEP** — an onchain action (swap, bridge, transfer)

Each ONCHAIN_STEP has:
- `status` — COMPLETE, FAILED, or in-progress
- `net_effect.consume` — tokens consumed (with `account`, `resource.asset`, `amount`, optional `tx_id`)
- `net_effect.produce` — tokens produced (with `account`, `resource.asset`, `amount`, optional `tx_id`)
- `step_index` — position in the workflow

Account types in route effects:
- `USER` — the user's wallet
- `PROCESSING_ADDRESS` / `SPW` — the OTW
- `DEST` — the destination address

The final `ONCHAIN_STEP` with `net_effect.produce` where `account === "DEST"` is the delivery transaction.
