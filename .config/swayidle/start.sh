#!/bin/bash
# Swayidle wrapper - waits for niri to be ready

LOG_FILE="/tmp/swayidle.log"

echo "[$(date)] Swayidle starting..." >> "$LOG_FILE"

# Wait for niri to fully initialize
sleep 5

echo "[$(date)] Niri should be ready, starting swayidle" >> "$LOG_FILE"

# Now start swayidle with proper config
exec swayidle -w \
    timeout 600 'niri msg output * off' \
    resume 'niri msg output * on' \
    2>> "$LOG_FILE"
