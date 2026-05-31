#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$FRONTEND_DIR"

COUNT=2
SKIP_BUILD=0
AUTOLOGIN=1
USER_PREFIX="test"
PASSWORD="1234567890"
# default to a phone-sized portrait window; override with --size=WIDTHxHEIGHT
WIN_WIDTH=400
WIN_HEIGHT=860
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=1 ;;
    --no-login) AUTOLOGIN=0 ;;
    --user-prefix=*) USER_PREFIX="${arg#*=}" ;;
    --password=*) PASSWORD="${arg#*=}" ;;
    --size=*) WIN_WIDTH="${arg#*=}"; WIN_WIDTH="${WIN_WIDTH%x*}"; WIN_HEIGHT="${arg##*x}" ;;
    ''|*[!0-9]*) echo "Ignoring unrecognized argument: $arg" >&2 ;;
    *) COUNT="$arg" ;;
  esac
done

# the Linux runner reads these to set its initial window size (see
# linux/runner/my_application.cc); children inherit them once exported
export WERWOLF_WINDOW_WIDTH="$WIN_WIDTH"
export WERWOLF_WINDOW_HEIGHT="$WIN_HEIGHT"

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

echo "Launching $COUNT isolated instance(s) at ${WIN_WIDTH}x${WIN_HEIGHT}..."
for ((i = 1; i <= COUNT; i++)); do
  RUN_DIR="/tmp/werwolf_client_$i"
  rm -rf "$RUN_DIR"
  cp -r "$BUNDLE" "$RUN_DIR"
  if [[ "$AUTOLOGIN" -eq 1 ]]; then
    USERNAME="${USER_PREFIX}${i}"
    WERWOLF_AUTOLOGIN_USER="$USERNAME" WERWOLF_AUTOLOGIN_PASS="$PASSWORD" "$RUN_DIR/werwolf" &
    PIDS+=("$!")
    echo "    instance $i ->  $RUN_DIR (pid $!) [auto-login: $USERNAME]"
  else
    "$RUN_DIR/werwolf" &
    PIDS+=("$!")
    echo "    instance $i ->  $RUN_DIR (pid $!)"
  fi
done

echo "All instances running. Press Ctrl-C to stop them all."
wait
