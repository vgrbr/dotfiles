#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <local|global|new> <app-id-regex> <command> [args...]" >&2
    exit 2
fi

mode="$1"
app_id_regex="$2"
shift 2
spawn_cmd=("$@")

spawn_new() {
    "${spawn_cmd[@]}" &
    disown || true
}

get_json() {
    niri msg --json "$1" 2>/dev/null || true
}

windows_json="$(get_json windows)"

if [[ "$mode" == "new" ]]; then
    spawn_new
    exit 0
fi

if [[ -z "$windows_json" || "$windows_json" == "null" ]]; then
    spawn_new
    exit 0
fi

focused_window_json="$(get_json focused-window)"
workspaces_json="$(get_json workspaces)"

focused_id="$(
    jq -r '.id // empty' <<<"$focused_window_json" 2>/dev/null || true
)"

focused_workspace_id="$(
    jq -r '.workspace_id // empty' <<<"$focused_window_json" 2>/dev/null || true
)"

if [[ -z "$focused_workspace_id" ]]; then
    focused_workspace_id="$(
        jq -r '
            .[]
            | select(.is_focused == true)
            | .id // empty
        ' <<<"$workspaces_json" 2>/dev/null | head -n1
    )"
fi

all_matches="$(
    jq -c --arg re "$app_id_regex" '
        [
            .[]
            | select((.app_id // "") | test($re))
            | {
                id,
                workspace_id,
                is_focused: (.is_focused // false)
            }
        ]
    ' <<<"$windows_json"
)"

if [[ "$mode" == "local" ]]; then
    candidate_matches="$(
        jq -c --arg ws "$focused_workspace_id" '
            map(select((.workspace_id | tostring) == $ws))
        ' <<<"$all_matches"
    )"
else
    candidate_matches="$all_matches"
fi

candidate_count="$(jq 'length' <<<"$candidate_matches")"

if [[ "$candidate_count" -eq 0 ]]; then
    spawn_new
    exit 0
fi

target_id="$(
    jq -r --arg focused_id "$focused_id" '
        if length == 1 then
            .[0].id
        else
            ([.[].id] | index(($focused_id | tonumber)?)) as $idx
            | if $idx == null then
                .[0].id
            else
                .[(($idx + 1) % length)].id
            end
        end
    ' <<<"$candidate_matches"
)"

exec niri msg action focus-window --id "$target_id"
