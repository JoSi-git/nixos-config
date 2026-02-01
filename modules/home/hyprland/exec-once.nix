{ ... }: {
  wayland.windowManager.hyprland.settings.exec-once = [
        "swww-daemon &"
        "hyprlock"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "battery_check &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "quickshell"
#        "waybar &"
  ];
}
