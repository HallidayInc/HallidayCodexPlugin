#!/usr/bin/env bash
set -euo pipefail

# Authenticated Halliday API call wrapper.
# Validates the endpoint against an allowlist before making the request.

BASE_URL="https://v2.prod.halliday.xyz"

ALLOWED_ENDPOINTS=(
  "GET /payments"
  "GET /payments/history"
  "POST /payments/balances"
  "GET /chains"
  "GET /assets"
  "GET /assets/available-outputs"
  "GET /assets/available-inputs"
)

usage() {
  echo "Usage: api-fetch.sh <API_KEY> <METHOD> <ENDPOINT> [QUERY_STRING] [JSON_BODY]"
  echo ""
  echo "Arguments:"
  echo "  API_KEY       Halliday public API key (pk_...)"
  echo "  METHOD        HTTP method (GET or POST)"
  echo "  ENDPOINT      API endpoint path (e.g. /payments)"
  echo "  QUERY_STRING  Query string for GET requests (e.g. payment_id=abc123)"
  echo "  JSON_BODY     JSON body for POST requests"
  echo ""
  echo "Allowed endpoints:"
  for ep in "${ALLOWED_ENDPOINTS[@]}"; do
    echo "  $ep"
  done
  echo ""
  echo "Examples:"
  echo "  api-fetch.sh pk_key GET /payments 'payment_id=abc123'"
  echo "  api-fetch.sh pk_key GET /payments/history 'owner_address=0x123&limit=10'"
  echo "  api-fetch.sh pk_key POST /payments/balances '' '{\"payment_id\":\"abc123\"}'"
  echo "  api-fetch.sh pk_key GET /chains"
  exit 1
}

if [ $# -lt 3 ]; then
  usage
fi

API_KEY="$1"
METHOD=$(echo "$2" | tr '[:lower:]' '[:upper:]')
ENDPOINT="$3"
QUERY_STRING="${4:-}"
JSON_BODY="${5:-}"

# Validate method
if [ "$METHOD" != "GET" ] && [ "$METHOD" != "POST" ]; then
  echo "Error: Method must be GET or POST, got '$METHOD'"
  exit 1
fi

# Validate endpoint against allowlist
ALLOWED=false
for ep in "${ALLOWED_ENDPOINTS[@]}"; do
  EP_METHOD=$(echo "$ep" | cut -d' ' -f1)
  EP_PATH=$(echo "$ep" | cut -d' ' -f2)
  if [ "$METHOD" = "$EP_METHOD" ] && [ "$ENDPOINT" = "$EP_PATH" ]; then
    ALLOWED=true
    break
  fi
done

if [ "$ALLOWED" = false ]; then
  echo "Error: '$METHOD $ENDPOINT' is not an allowed endpoint."
  echo ""
  echo "Allowed endpoints:"
  for ep in "${ALLOWED_ENDPOINTS[@]}"; do
    echo "  $ep"
  done
  exit 1
fi

# Build the full URL
URL="${BASE_URL}${ENDPOINT}"
if [ -n "$QUERY_STRING" ]; then
  URL="${URL}?${QUERY_STRING}"
fi

# Make the request
if [ "$METHOD" = "GET" ]; then
  curl -s -w "\n%{http_code}" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    "$URL"
elif [ "$METHOD" = "POST" ]; then
  if [ -z "$JSON_BODY" ]; then
    echo "Error: POST requests require a JSON body"
    exit 1
  fi
  curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$JSON_BODY" \
    "$URL"
fi
