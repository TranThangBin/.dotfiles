cliphist="$SCRIPT_DIR/dependencies/bin/cliphist"
wofi="$SCRIPT_DIR/dependencies/bin/wofi"

prompt="Clipboard delete:"

"$cliphist" list |
    "$wofi" -S dmenu -p "$prompt" |
    "$cliphist" delete
