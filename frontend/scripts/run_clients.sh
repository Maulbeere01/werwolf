#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$FRONTEND_DIR"

COUNT=2
SKIP_BUILD=0
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=1 ;;
    ''|*[!0-9]*) echo "Ignoring unrecognized argument: $arg" >&2 ;;
    *) COUNT="$arg" ;;
  esac
done

BUNDLE="build/linux/x64/debug/bundle"

if [[ "$SKIP_BUILD" -eq 0 ]]; then
  echo "Building Linux debug bundle once"
  flutter build linux --debug
fi

if [[ ! -x "$BUNDLE/werwolf" ]]; then
  echo "Error: $BUNDLE/werwolf not found. Run without --skip-build first." >&2
  exit 1
fi

PIDS=()
cleanup() {
  echo
  echo "Stopping ${#PIDS[@]} instance(s)..."
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
}
trap cleanup EXIT INT TERM

echo "Launching $COUNT isolated instance(s)..."
for ((i = 1; i <= COUNT; i++)); do
  RUN_DIR="/tmp/werwolf_client_$i"
  rm -rf "$RUN_DIR"
  cp -r "$BUNDLE" "$RUN_DIR"
  "$RUN_DIR/werwolf" &
  PIDS+=("$!")
  echo "    instance $i ->  $RUN_DIR (pid $!)"
done

echo "All instances running. Press Ctrl-C to stop them all."
wait
