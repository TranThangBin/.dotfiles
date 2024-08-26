#!/usr/bin/bash
if type "xandr"; then
    for m in $(xrand --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload example &
    done
else
    polybar --reload example &
fi
