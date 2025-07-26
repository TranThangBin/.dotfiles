cliphist="$SCRIPT_DIR/dependencies/bin/cliphist"
wofi="$SCRIPT_DIR/dependencies/bin/wofi"
wl_copy="$SCRIPT_DIR/dependencies/bin/wl-copy"

prompt="Clipboard pick:"

"$cliphist" list |
    "$wofi" -S dmenu -p "$prompt" |
    "$cliphist" decode |
    "$wl_copy"
