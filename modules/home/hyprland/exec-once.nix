{ pkgs, config, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    env = lib.mapAttrsToList (n: v: "${n},${builtins.toString v}") config.home.sessionVariables;

    exec-once = [
      "dbus-update-activation-environment --systemd --all"
      "systemctl --user import-environment --all"

      "awww-daemon &"
      "hyprlock"
      "battery_check &"
      "wl-clip-persist --clipboard both &"
      "wl-paste --watch cliphist store &"
      "quickshell"
      "quickshell -p ~/.config/quickshell/Overview"
    ];
  };
}
