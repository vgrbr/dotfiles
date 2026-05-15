#!/bin/bash
# Swayidle wrapper - waits for niri to be ready

LOG_FILE="/tmp/swayidle.log"

echo "[$(date)] Swayidle starting..." >> "$LOG_FILE"

# Wait for niri to fully initialize
sleep 5

echo "[$(date)] Niri should be ready, starting swayidle" >> "$LOG_FILE"

# Lock and power off displays after 5 minutes of inactivity.
exec swayidle -w \
    timeout 300 '"$HOME"/dotfiles/.config/niri/bin/lock-and-power-off.sh' \
    resume 'niri msg output * on' \
    2>> "$LOG_FILE"
