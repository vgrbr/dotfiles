#!/usr/bin/env python3
"""Apply app-specific keyd bindings based on niri focus events.
Replaces keyd-application-mapper which doesn't work reliably on niri."""

import subprocess
import sys
import re

BINDINGS = {
    'com.mitchellh.ghostty': [
        'meta.c = C-S-c',
        'meta.t = C-S-t',
        'meta.w = C-S-w',
    ],
}

BROWSER_RE = re.compile(
    r'firefox|librewolf|zen|floorp|chromium|chrome|brave|vivaldi|opera|edge|helium',
    re.IGNORECASE
)
BROWSER_BINDINGS = ['meta.r = C-r']

def get_bindings(app_id):
    if app_id in BINDINGS:
        return BINDINGS[app_id]
    if BROWSER_RE.search(app_id):
        return BROWSER_BINDINGS
    return []

def apply_bindings(bindings):
    subprocess.run(
        ['keyd', 'bind', 'reset', *bindings],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

current_app = None

# Use line-buffered reads so focus events are processed immediately
sys.stdin.reconfigure(line_buffering=True)
while True:
    line = sys.stdin.readline()
    if not line:
        break
    if 'is_focused: true' not in line:
        continue
    m = re.search(r'app_id: Some\("([^"]+)"\)', line)
    if not m:
        continue
    app_id = m.group(1)
    if app_id == current_app:
        continue
    current_app = app_id
    apply_bindings(get_bindings(app_id))
