# Example Repositories

All example repositories are hosted at https://github.com/HallidayInc.

## SDK Widget Examples

Use these when the developer wants the drop-in widget UI.

| Repository | Description | Best For |
|------------|-------------|----------|
| [HallidayPaymentsSdkExamples](https://github.com/HallidayInc/HallidayPaymentsSdkExamples) | SDK widget in vanilla JS | Projects without frameworks |
| [HallidaySdkDynamicEthers](https://github.com/HallidayInc/HallidaySdkDynamicEthers) | SDK widget + Dynamic wallet + Ethers.js | React apps with Dynamic using Ethers |
| [HallidaySdkDynamicWagmi](https://github.com/HallidayInc/HallidaySdkDynamicWagmi) | SDK widget + Dynamic wallet + Wagmi | React apps with Dynamic using Wagmi |
| [HallidaySdkPrivyReactExample](https://github.com/HallidayInc/HallidaySdkPrivyReactExample) | SDK widget + Privy + Vite | React apps with Privy |
| [HallidaySdkViemWagmiRainbowkitExample](https://github.com/HallidayInc/HallidaySdkViemWagmiRainbowkitExample) | SDK widget + Viem + Wagmi + Rainbowkit | React apps with Rainbowkit |
| [HallidaySdkReactNative](https://github.com/HallidayInc/HallidaySdkReactNative) | SDK widget in WebView + Reown + Expo + Ethers.js | React Native apps |

## Custom UI via API Examples

Use these when the developer wants full control over the payment interface.

| Repository | Description | Best For |
|------------|-------------|----------|
| [HallidayPaymentsApiExamples](https://github.com/HallidayInc/HallidayPaymentsApiExamples) | API + custom UI in vanilla JS + Ethers.js | Vanilla JS with custom UI |
| [HallidayPaymentsApiExamplesReact](https://github.com/HallidayInc/HallidayPaymentsApiExamplesReact) | API + custom UI in React | React apps with custom UI |
| [HallidayApiDynamicExamplesWagmi](https://github.com/HallidayInc/HallidayApiDynamicExamplesWagmi) | API + Dynamic + Wagmi + custom UI | React + Dynamic with custom UI |
| [HallidayApiPrivyReactExamples](https://github.com/HallidayInc/HallidayApiPrivyReactExamples) | API + Privy + Vite + custom UI | React + Privy with custom UI |
| [HallidayApiReactNative](https://github.com/HallidayInc/HallidayApiReactNative) | API + Reown + Expo + Wagmi + optional Dynamic embedded wallet | React Native apps with custom UI |

## Selecting the Right Example

1. **Does the developer want the widget or custom UI?**
   - Widget → SDK Widget Examples
   - Custom UI → Custom UI via API Examples

2. **What framework are they using?**
   - No framework → Vanilla examples
   - React → React examples
   - React Native → React Native examples

3. **What wallet provider?**
   - Dynamic → Dynamic examples
   - Privy → Privy examples
   - Rainbowkit → Rainbowkit example
   - Other/none → Vanilla or basic React examples

4. **What web3 library?**
   - Wagmi → Wagmi examples
   - Ethers.js → Ethers examples

## Fetching Example Code

To fetch a repo's README for setup instructions:
```
web_fetch https://raw.githubusercontent.com/HallidayInc/{REPO_NAME}/main/README.md
```

To fetch specific source files from a repo:
```
web_fetch https://raw.githubusercontent.com/HallidayInc/{REPO_NAME}/main/{FILE_PATH}
```
