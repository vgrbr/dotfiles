#!/usr/bin/env bash
set -euo pipefail

qs -c noctalia-shell ipc call lockScreen lock

# Give the lock surface a moment to appear before DPMS powers outputs down.
sleep 0.2

niri msg action power-off-monitors
