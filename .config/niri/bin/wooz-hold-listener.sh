#!/usr/bin/env bash

set -euo pipefail

layer_name="${WOOZ_KEYD_LAYER:-wooz_hold}"
wooz_bin="${WOOZ_BIN:-$HOME/projects/wooz/build/wooz}"
wooz_args=(
  --zoom-in
  25%
  --mouse-track
)

start_wooz() {
  pgrep -x wooz >/dev/null 2>&1 && return 0
  "$wooz_bin" "${wooz_args[@]}" >/dev/null 2>&1 &
}

stop_wooz() {
  pkill -x wooz >/dev/null 2>&1 || true
}

cleanup() {
  stop_wooz
}

trap cleanup EXIT INT TERM HUP

if [[ ! -x "$wooz_bin" ]]; then
  printf 'wooz-hold-listener: missing executable: %s\n' "$wooz_bin" >&2
  exit 1
fi

while true; do
  while IFS= read -r line; do
    case "$line" in
      "+$layer_name")
        start_wooz
        ;;
      "-$layer_name")
        stop_wooz
        ;;
    esac
  done < <(keyd listen)

  sleep 1
done
