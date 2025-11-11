#!/usr/bin/env bash
kitty -e neofetch &
sleep 0.5
wid=$(hyprctl clients | awk '/kitty/ {print $2}' | tail -n1)
[[ -n $wid ]] && hyprctl dispatch togglefloating "$wid" && hyprctl dispatch focuswindow "$wid"
