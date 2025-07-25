WOFI_BIN="$1"
CLIPHIST_BIN="$2"

confirm=$(echo -e "no\nyes" | "$WOFI_BIN" -S dmenu -p 'Do you want to wipe the clipboard?')
if [[ $confirm = "yes" ]]; then
    "$CLIPHIST_BIN" wipe
fi
