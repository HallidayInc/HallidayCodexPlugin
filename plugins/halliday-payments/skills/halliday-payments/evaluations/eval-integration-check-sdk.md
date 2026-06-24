# Evaluation: SDK Widget Integration Check

## Input Query

"Can you check my Halliday integration? I'm using the SDK widget in a React app."

## Expected Behavior

1. The `halliday` skill activates based on keyword match ("Halliday integration")
2. Codex presents the initialization menu (or routes directly from the question)
3. Codex identifies this as an integration check request
4. Codex reads `reference/integration-checklist.md`
5. Codex determines the integration type is SDK Widget
6. Codex scans the codebase:
   - Search for `@halliday-sdk/payments`, `openHallidayPayments`, `initializeClient`
   - If no results found, asks the developer to specify files
7. Codex reads the matching source files
8. Codex reads `package.json` to check for `@halliday-sdk/payments`
9. Codex evaluates each SDK Widget checklist item against the code:
   - Package installed
   - Required parameters (apiKey, outputs)
   - Owner wallet actions (signTypedData, signMessage, sendTransaction)
   - Window type / target element pairing
   - API key handling (not hardcoded)
10. Codex reports findings with PASS / MISSING / WARNING and severity levels
11. For MISSING items, Codex explains the edge case and provides implementation guidance

## Expected Files Loaded

- `SKILL.md` (via skill activation)
- `reference/integration-checklist.md` (for the checklist)
- Developer's source files containing Halliday integration code
- Developer's `package.json`

## What Should NOT Happen

- Should NOT load `reference/payment-lookup-guide.md` — this is not a payment lookup
- Should NOT call `api-fetch.sh` or make any Halliday API calls — this is a code review, not a live check
- Should NOT load `reference/api-integration.md` — the developer is using the SDK widget
- Should NOT fabricate checklist items that aren't in `reference/integration-checklist.md`
- Should NOT mark `statusCallback` as CRITICAL or MISSING — it is optional
- Should NOT recommend switching to the API approach unless the developer asks
- Should NOT read all source files in the project — only files containing Halliday code
- Should NOT fetch external documentation
