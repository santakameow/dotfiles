#!/bin/sh

zenity --question \
    --title="end session" \
    --text="u want nuke hyprland?" \
    --ok-label="yes" \
    --cancel-label="NO" || exit 0

command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'

