# Common Developer Questions

## Integration

**"How do I add crypto payments to my app?"**
Recommend the SDK widget. It handles the full payment flow with minimal code. Read [sdk-widget-integration.md](sdk-widget-integration.md) for details. Point to the example repo that matches their stack — see [example-repositories.md](example-repositories.md).

**"How do I build a custom deposit/payment UI?"**
Two options: (1) Use the SDK widget — it supports custom styling and covers most use cases. (2) Use the API for full UI control. Read [api-integration.md](api-integration.md) for details.

**"What wallets are supported?"**
Any EVM-compatible wallet: Dynamic, Privy, RainbowKit, MetaMask, WalletConnect, etc. Additional wallet support is added frequently.

**"Can I integrate on mobile?"**
Yes. React Native apps can use the SDK widget. Native mobile apps (Swift/Kotlin) should use the API approach. Note: payment provider screens (Stripe, Moonpay) require a secure mobile browser — plain WebViews won't work for payment input.

## API and Data

**"Which chains are supported?"**
Query the API live: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /chains`. This returns the current list of supported chains with chain IDs, explorer URLs, and native currency info. Present the results in a readable format.

**"Which assets/tokens are supported?"**
Discover supported routes via `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /assets/available-outputs "inputs[]=<INPUT>"` (or `/assets/available-inputs` for the reverse). To fetch metadata for specific assets, pass them explicitly: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /assets "assets[]=<ASSET>"`. Summarize results by chain for readability.

**"Can I convert X to Y?" / "Is this route available?"**
Query the API live: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /assets/available-outputs "inputs[]=<INPUT>&outputs[]=<OUTPUT>"`. If the output asset appears in the response, the route is supported. An empty `{}` response means the route is not currently available.

**"How do I handle webhooks?"**
Webhook support is coming soon. Currently, use polling or the SDK's built-in state management to track transaction status.

## Access and Compliance

**"How do I get a public API key?"**
Go to https://dashboard.halliday.xyz/ to create a free account and generate a key. As a backup, email partnerships@halliday.xyz.

**"Is there a test environment?"**
Contact the Halliday team for test information.

**"Is KYC required?"**
Only for fiat onramps (handled by the provider, not Halliday). Coinbase allows no-KYC up to $500 USD. No KYC for crypto-to-crypto swaps. See [compliance-and-requirements.md](compliance-and-requirements.md).

**"What fiat currencies are supported?"**
USD and EUR for fiat onramping.

**"What countries are restricted?"**
Restrictions vary by fiat onramp provider and change frequently. No restrictions on crypto-to-crypto swaps. See [compliance-and-requirements.md](compliance-and-requirements.md).

## Try It Live

Developers can experience the Halliday widget at https://halliday.xyz/ — click "Try it now" on the home page.
