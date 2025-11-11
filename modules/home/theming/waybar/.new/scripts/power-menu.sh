#!/usr/bin/env bash

config="$HOME/.config/rofi/power-menu.rasi"

actions=$(echo -e "  Lock\n  Shutdown\n  Reboot")

# Display power menu
selected_option=$(echo -e "$actions" | rofi -dmenu -i -config "${config}" || pkill -x rofi)

# Perform action based on selected option
case "$selected_option" in
*Lock)
  hyprlock & sleep 0.5
  ;;
*Shutdown)
  systemctl poweroff
  ;;
*Reboot)
  systemctl reboot
  ;;
esac
