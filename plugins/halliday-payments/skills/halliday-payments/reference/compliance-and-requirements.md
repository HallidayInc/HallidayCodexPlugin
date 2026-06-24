# Compliance and Requirements

## Fiat Onramp Providers

Halliday routes through multiple fiat-onramp providers: Stripe, Moonpay, Unlimit, Transak, and CEXs (including Coinbase). Provider selection is handled automatically based on availability and user eligibility.

## KYC (Know Your Customer)

- **Fiat onramps**: KYC is required. It is handled entirely by the onramp provider (Stripe, Moonpay, etc.) — Halliday does not perform KYC itself.
- **Coinbase onramp**: No-KYC fiat onramping up to $500 USD.
- **Crypto-to-crypto swaps**: No KYC required.

## Geographic Restrictions

- **Fiat onramps**: Restrictions vary by provider and change frequently. Each provider has its own supported/restricted country list.
- **Crypto-to-crypto swaps**: No geographic restrictions.

## Supported Fiat Currencies

USD and EUR for fiat onramping.

## Transaction Limits

Minimum and maximum transaction amounts for fiat onramps vary by provider. There are no Halliday-imposed limits on crypto-to-crypto swaps.

## Supported Chains and Assets

Chain and asset support changes frequently. Query the API for live data:
- Supported chains: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /chains`
- Supported assets: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /assets`
- Check a specific route: `<PLUGIN_ROOT>/skills/halliday-payments/scripts/api-fetch.sh <KEY> GET /assets/available-outputs "inputs[]=<INPUT>&outputs[]=<OUTPUT>"`
