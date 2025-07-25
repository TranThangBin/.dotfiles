CLIPHIST_BIN="$1"
WOFI_BIN="$2"

"$CLIPHIST_BIN" list |
    "$WOFI_BIN" -S dmenu -p 'Clipboard delete:' |
    "$CLIPHIST_BIN" delete
