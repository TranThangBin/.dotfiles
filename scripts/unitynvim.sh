#!/usr/bin/env bash

neovim="$SCRIPT_DIR/dependencies/bin/nvim"
neovide="$SCRIPT_DIR/dependencies/bin/neovide"

# $(File) $(Line)
FILE="$3"
LINE="$4"

PIPE="$PWD/unitynvim"

if [[ -S "$PIPE" ]]; then
    "$neovim" --server "$PIPE" --remote-send "<C-\><C-n>:n${FILE}<CR>${LINE}gg^"
else
    "$neovide" "$FILE" -- --listen "$PIPE"
fi
