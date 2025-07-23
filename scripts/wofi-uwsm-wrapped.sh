WOFI_BIN="$1"
UWSM_APP_BIN="$2"

shift 2

app=$("$WOFI_BIN" --show drun --define=drun-print_desktop_file=true)
if [[ "$app" == *'desktop '* ]]; then
    "$UWSM_APP_BIN" "''${app%.desktop *}.desktop:''${app#*.desktop }" "$@"
elif [[ "$app" == *'desktop' ]]; then
    "$UWSM_APP_BIN" "$app" "$@"
fi
