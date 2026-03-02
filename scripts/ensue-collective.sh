#!/bin/bash
# Ensue Collective Intelligence API wrapper
# Usage: ./scripts/ensue-collective.sh <method> <json_args>

METHOD="$1"
ARGS="$2"

if [ -z "$ENSUE_COLLECTIVE_KEY" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  KEY_FILE="$SCRIPT_DIR/../.collective-key"
  if [ -f "$KEY_FILE" ]; then
    ENSUE_COLLECTIVE_KEY=$(cat "$KEY_FILE")
  fi
fi

if [ -z "$ENSUE_COLLECTIVE_KEY" ]; then
  echo '{"error":"ENSUE_COLLECTIVE_KEY not set. Run the collective intelligence setup first."}'
  exit 1
fi

if [ -z "$METHOD" ]; then
  echo '{"error":"No method specified. Usage: ensue-collective.sh <method> <json_args>"}'
  exit 1
fi

[ -z "$ARGS" ] && ARGS='{}'

curl -s -X POST https://api.ensue-network.ai/ \
  -H "Authorization: Bearer $ENSUE_COLLECTIVE_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"tools/call\",\"params\":{\"name\":\"$METHOD\",\"arguments\":$ARGS},\"id\":1}" \
  | sed 's/^data: //'
