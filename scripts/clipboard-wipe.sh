cliphist="$SCRIPT_DIR/dependencies/bin/cliphist"
wofi="$SCRIPT_DIR/dependencies/bin/wofi"

prompt="Do you want to wipe the clipboard?"

confirm=$({
    echo no
    echo yes
} | "$wofi" -S dmenu -p "$prompt")
if [[ $confirm = "yes" ]]; then
    "$cliphist" wipe
fi
