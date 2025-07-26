#!/usr/bin/env bash

wofi="$SCRIPT_DIR/dependencies/bin/wofi"
uwsm_app="$SCRIPT_DIR/dependencies/bin/uwsm-app"

app=$("$wofi" --show drun --define=drun-print_desktop_file=true)
if [[ "$app" == *'desktop '* ]]; then
    "$uwsm_app" "''${app%.desktop *}.desktop:''${app#*.desktop }"
elif [[ "$app" == *'desktop' ]]; then
    "$uwsm_app" "$app"
fi
