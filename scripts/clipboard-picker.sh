CLIPHIST_BIN="$1"
WOFI_BIN="$2"
WL_COPY_BIN="$3"

"$CLIPHIST_BIN" list |
    "$WOFI_BIN" -S dmenu -p 'Clipboard pick:' |
    "$CLIPHIST_BIN" decode |
    "$WL_COPY_BIN"
