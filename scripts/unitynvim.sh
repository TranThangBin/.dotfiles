#!/usr/bin/env bash

NEOVIM_BIN="$1"
NEOVIDE_BIN="$2"

# $(File) $(Line)
FILE="$3"
LINE="$4"

PIPE="$PWD/unitynvim"

if [[ -S "$PIPE" ]]; then
    "$NEOVIM_BIN" --server "$PIPE" --remote-send "<C-\><C-n>:n${FILE}<CR>${LINE}gg^"
else
    "$NEOVIDE_BIN" "$FILE" -- --listen "$PIPE"
fi
