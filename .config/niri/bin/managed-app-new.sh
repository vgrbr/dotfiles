#!/usr/bin/env bash
set -euo pipefail

focused_window_json="$(niri msg --json focused-window 2>/dev/null || true)"

if [[ -z "$focused_window_json" || "$focused_window_json" == "null" ]]; then
    exit 1
fi

app_id="$(jq -r '.app_id // empty' <<<"$focused_window_json" 2>/dev/null || true)"

case "$app_id" in
    com.mitchellh.ghostty)
        exec ghostty
        ;;
    helium|Helium|helium-browser|Helium-browser)
        exec helium-browser
        ;;
    chrome-gmgnghphiockcigbjihhdnnmmcbdcjdf-Profile_1)
        exec chromium "--profile-directory=Profile 1" --app-id=gmgnghphiockcigbjihhdnnmmcbdcjdf
        ;;
    *)
        exit 1
        ;;
esac
