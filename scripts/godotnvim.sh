#!/usr/bin/env bash

NEOVIM_BIN="$1"
NEOVIDE_BIN="$2"

# {file} {Line} {col}
FILE="$3"
LINE="$4"
COL="$5"

PIPE="$PWD/godotnvim"

if [[ -S "$PIPE" ]]; then
    "$NEOVIM_BIN" --server "$PIPE" --remote-send "<C-\><C-n>:n${FILE}<CR>${LINE}gg${COL}|"
else
    "$NEOVIDE_BIN" "$FILE" -- --listen "$PIPE"
fi
