# SDK Widget Integration

The Halliday SDK widget is a drop-in UI component that handles the entire payment flow: fiat onramps, cross-chain swaps, and crypto deposits. It is the recommended integration approach for most applications.

## When to Use

- Web applications (any framework)
- React Native mobile apps
- Any project where a pre-built payment UI is acceptable

## Installation

```bash
npm install @halliday-sdk/payments
```

Or load via CDN:
```html
<script src="https://cdn.jsdelivr.net/npm/@halliday-sdk/payments@latest/dist/paymentsWidget/index.umd.min.js"></script>
```

## Basic Usage

The widget is opened by calling `openHallidayPayments()` with a configuration object. Do NOT guess or fabricate configuration parameters — refer to the official documentation for the exact config shape.

**To get the current configuration options and parameters:**
Read `<PLUGIN_ROOT>/sources/sdk/index.d.ts` (small enough to load whole) for all TypeScript types and `openHallidayPayments()` params. For additional context, search `<PLUGIN_ROOT>/sources/docs/` for the `openHallidayPayments` section.

## Customization

The SDK widget supports custom styling (colors, branding). search `<PLUGIN_ROOT>/sources/docs/` for `customizing-styles` or `theme` to find the styling configuration options.

## Wallet Compatibility

Works with any EVM-compatible wallet provider:
- Dynamic
- Privy
- RainbowKit
- MetaMask
- WalletConnect
- Viem
- Wagmi
- Any other EVM wallet

A wallet provider object can be passed to the widget configuration. Refer to the docs for the exact parameter name and format.

## Mobile Considerations

- The SDK widget works in mobile browsers and WebViews
- Payment provider screens (Stripe, Moonpay card input, etc.) require opening a standard secure mobile browser — plain WebViews lack the necessary security features for payment processing
- For React Native: use the SDK widget within a WebView, but handle payment provider redirects in the native browser

## Example Repositories

| Repository | Stack |
|------------|-------|
| [HallidayPaymentsSdkExamples](https://github.com/HallidayInc/HallidayPaymentsSdkExamples) | Vanilla HTML/CSS/JS |
| [HallidaySdkDynamicEthers](https://github.com/HallidayInc/HallidaySdkDynamicEthers) | React + Dynamic + Ethers.js |
| [HallidaySdkDynamicWagmi](https://github.com/HallidayInc/HallidaySdkDynamicWagmi) | React + Dynamic + Wagmi |
| [HallidaySdkPrivyReactExample](https://github.com/HallidayInc/HallidaySdkPrivyReactExample) | React + Privy + Vite |
| [HallidaySdkViemWagmiRainbowkitExample](https://github.com/HallidayInc/HallidaySdkViemWagmiRainbowkitExample) | React + Viem + Wagmi + Rainbowkit |

To fetch an example's README for setup instructions:
```
web_fetch https://raw.githubusercontent.com/HallidayInc/{REPO_NAME}/main/README.md
```

## When to Use Raw Source Files

Use the local raw source files when:
- The developer needs the exact `openHallidayPayments()` configuration parameters → Read `<PLUGIN_ROOT>/sources/sdk/index.d.ts`
- The developer asks about a specific widget feature not covered here → search `<PLUGIN_ROOT>/sources/docs/`
- You need to provide a code example and must verify it against official sources → search `<PLUGIN_ROOT>/sources/docs/`

**Do not load all source files at once. Do not fetch external docs.**
