#!/usr/bin/env bash
set -euo pipefail

ALLOWED_REPOS=(
  HallidayPaymentsSdkExamples
  HallidaySdkDynamicEthers
  HallidaySdkDynamicWagmi
  HallidaySdkPrivyReactExample
  HallidaySdkViemWagmiRainbowkitExample
  HallidaySdkReactNative
  HallidayPaymentsApiExamples
  HallidayPaymentsApiExamplesReact
  HallidayApiDynamicExamplesWagmi
  HallidayApiPrivyReactExamples
  HallidayApiReactNative
)

if [ $# -eq 0 ]; then
  echo "Usage: git-fetch.sh <REPO_NAME>"
  echo ""
  echo "Allowed repositories:"
  for repo in "${ALLOWED_REPOS[@]}"; do
    echo "  $repo"
  done
  exit 1
fi

REPO="$1"

for allowed in "${ALLOWED_REPOS[@]}"; do
  if [ "$REPO" = "$allowed" ]; then
    git clone "https://github.com/HallidayInc/${REPO}.git"
    exit 0
  fi
done

echo "Error: '$REPO' is not an allowed repository."
echo ""
echo "Allowed repositories:"
for repo in "${ALLOWED_REPOS[@]}"; do
  echo "  $repo"
done
exit 1
