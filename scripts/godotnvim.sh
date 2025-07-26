#!/usr/bin/env bash

neovim="$SCRIPT_DIR/dependencies/bin/nvim"
neovide="$SCRIPT_DIR/dependencies/bin/neovide"

# {file} {Line} {col}
FILE="$1"
LINE="$2"
COL="$3"

PIPE="$PWD/godotnvim"

if [[ -S "$PIPE" ]]; then
    "$neovim" --server "$PIPE" --remote-send "<C-\><C-n>:n${FILE}<CR>${LINE}gg${COL}|"
else
    "$neovide" "$FILE" -- --listen "$PIPE"
fi
