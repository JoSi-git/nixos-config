{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [ "gtk" "hyprland" ];
        "org.freedesktop.impl.portal.Settings" = [ "none" ];
      };
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
