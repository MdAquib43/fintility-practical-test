#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"
LOG_FILE="${2:-./website_check.log}"
TIMEOUT_SECONDS=10

if [[ -z "$URL" ]]; then
  echo "Usage: $0 <url> [log_file]"
  exit 1
fi

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

set +e
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT_SECONDS" "$URL")
CURL_EXIT=$?
set -e
if [[ "$CURL_EXIT" -ne 0 || -z "$HTTP_STATUS" ]]; then
  HTTP_STATUS="000"
fi

if [[ "$HTTP_STATUS" =~ ^2|^3 ]]; then
  STATUS="UP"
else
  STATUS="DOWN"
fi

LOG_LINE="[$TIMESTAMP] URL=$URL STATUS=$STATUS HTTP_CODE=$HTTP_STATUS"
echo "$LOG_LINE" | tee -a "$LOG_FILE"

[[ "$STATUS" == "DOWN" ]] && exit 1 || exit 0
