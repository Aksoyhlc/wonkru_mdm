#!/usr/bin/env bash
#
# Writes the server URL and enrollment key into the app's storage through an
# Android intent, so a device can be enrolled over ADB without typing the key.
#
# Usage:
#   ./tool/adb_enroll.sh --key WNKR-XXXX-XXXX-XXXX [--server https://api.example.com] \
#     [--code ABC123] [--serial SERIAL]
#
# --key    enrollment key (required unless --server is enough for a re-run)
# --server server base URL (optional; normally carried by the QR)
# --code   pre-assigned device code (optional)
# --serial target device when several are connected (optional)
set -euo pipefail

PACKAGE="com.wonkrumdm"
ACTIVITY=".MainActivity"

server=""
key=""
code=""
serial=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --server) server="${2:-}"; shift 2 ;;
    --key) key="${2:-}"; shift 2 ;;
    --code) code="${2:-}"; shift 2 ;;
    --serial) serial="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$server" && -z "$key" ]]; then
  echo "Provide at least --key (and usually --server). See --help." >&2
  exit 1
fi

adb_cmd=(adb)
if [[ -n "$serial" ]]; then
  adb_cmd+=(-s "$serial")
fi

# A singleTask activity reuses onNewIntent; force-stop makes the intent
# deterministic and delivers it through onCreate.
"${adb_cmd[@]}" shell am force-stop "$PACKAGE"

start_args=(shell am start -n "$PACKAGE/$ACTIVITY")
if [[ -n "$server" ]]; then start_args+=(--es server_url "$server"); fi
if [[ -n "$key" ]]; then start_args+=(--es enrollment_key "$key"); fi
if [[ -n "$code" ]]; then start_args+=(--es device_code "$code"); fi

"${adb_cmd[@]}" "${start_args[@]}"

echo "Setup values sent to $PACKAGE."
