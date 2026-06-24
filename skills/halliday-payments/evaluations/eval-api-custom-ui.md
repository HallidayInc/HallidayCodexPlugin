# Evaluation: Custom UI via API

## Input Query

"I'm building a native iOS app in Swift. I need to let users buy crypto and deposit it into our app. How do I integrate Halliday with a custom UI?"

## Expected Behavior

1. The `halliday` skill activates based on keyword match ("buy crypto", "deposit")
2. Codex reads `reference/api-integration.md` (not SDK widget reference)
3. Codex correctly identifies that native iOS (Swift) requires the API approach — the SDK widget is web/React Native only
4. Codex identifies `HallidayPaymentsApiExamples` or a React-based API example as reference, while noting the developer will need to adapt for Swift
5. For API endpoint details, Codex uses `search` on `<PLUGIN_ROOT>/sources/api/openapi.json` for the relevant endpoint, then read only the matching lines (±50 lines of context)
6. Codex mentions that payment provider screens require a secure mobile browser, not a plain WebView

## Expected Files Loaded

- `SKILL.md` (via skill activation)
- `reference/api-integration.md` (for API integration details)
- `reference/example-repositories.md` (to suggest closest example)

## What Should NOT Happen

- Should NOT fetch any external docs — all source data is local in `<PLUGIN_ROOT>/sources/`
- Should NOT read `<PLUGIN_ROOT>/sources/api/openapi.json` or docs files whole — use search to find relevant sections
- Should NOT recommend the SDK widget for a native Swift iOS app
- Should NOT load `reference/sdk-widget-integration.md` (developer needs API, not widget)
- Should NOT fabricate Swift code examples — Halliday doesn't provide Swift examples
- Should NOT claim there's a native iOS SDK
- Should NOT load compliance reference unless the developer asks about KYC/restrictions
