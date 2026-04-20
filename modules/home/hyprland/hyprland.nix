{ inputs, pkgs,... }:
{
  home.packages = with pkgs; [
    cliphist
    direnv
    dust
    glib
    grim
    grimblast
    hyprkeys
    hyprpicker
    imagemagick
    libnotify
    satty
    awww
    slurp
    tesseract
    wayland
    wf-recorder
    wl-clip-persist
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    xwayland = {
      enable = true;
      #hidpi = true;
    };

    # enableNvidiaPatches = false;
    systemd.enable = false;
  };
}
