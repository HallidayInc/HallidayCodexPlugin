# Evaluation: SDK Widget Integration in React

## Input Query

"I want to add crypto deposits to my React app. I'm using Dynamic for wallet connection with Wagmi."

## Expected Behavior

1. The `halliday` skill activates based on keyword match ("crypto deposits")
2. Codex reads `reference/sdk-widget-integration.md` (not all reference files)
3. Codex recommends the SDK widget as the integration approach
4. Codex identifies `HallidaySdkDynamicWagmi` as the matching example repo
5. Codex provides guidance based on the reference file content
6. If the developer asks for specific `openHallidayPayments()` parameters, Codex reads `<PLUGIN_ROOT>/sources/sdk/index.d.ts` (small enough to load whole) to verify them
7. Codex does NOT fabricate configuration parameters

## Expected Files Loaded

- `SKILL.md` (via skill activation)
- `reference/sdk-widget-integration.md` (for SDK widget details)
- `reference/example-repositories.md` (to confirm the right repo)

## What Should NOT Happen

- Should NOT fetch any external docs — all source data is local in `<PLUGIN_ROOT>/sources/`
- Should NOT read `<PLUGIN_ROOT>/sources/api/openapi.json` or docs files whole — use search for targeted lookups
- Should NOT load all five reference files at once
- Should NOT load `reference/api-integration.md` (developer asked for widget, not API)
- Should NOT load `reference/compliance-and-requirements.md` (not relevant to this question)
- Should NOT invent `openHallidayPayments()` parameters without verifying against docs
- Should NOT recommend the API approach unless the developer specifically asks about it
