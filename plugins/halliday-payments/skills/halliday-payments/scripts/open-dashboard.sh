#!/usr/bin/env bash
# Opens the Halliday dashboard in the developer's default browser so they can
# create a free account and generate a public API key. Takes no arguments — the
# URL is hardcoded so the auto-approve hook can safely fire-and-forget this call.

set -euo pipefail

URL="https://dashboard.halliday.xyz/"

case "$(uname -s)" in
  Darwin)
    open "$URL"
    ;;
  Linux)
    if command -v xdg-open >/dev/null 2>&1; then
      # Detach so we don't block on the browser process.
      (xdg-open "$URL" >/dev/null 2>&1 &)
    else
      echo "Could not find xdg-open. Please open this URL manually: $URL" >&2
      exit 1
    fi
    ;;
  CYGWIN*|MINGW*|MSYS*)
    # Empty "" is the window title arg required by `start`.
    cmd /c start "" "$URL"
    ;;
  *)
    echo "Unsupported platform ($(uname -s)). Please open this URL manually: $URL" >&2
    exit 1
    ;;
esac

echo "Opened Halliday dashboard in your default browser: $URL"
