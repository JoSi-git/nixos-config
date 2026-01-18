{ ... }: {
  wayland.windowManager.hyprland.settings.exec-once = [
        "hyprlock"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "poweralertd &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "quickshell"
#        "waybar &"
        "swww-daemon &"
  ];
}
