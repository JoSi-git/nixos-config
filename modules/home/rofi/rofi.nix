{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ rofi ];
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;

  # Hide helper/settings entries from Rofi
  xdg.desktopEntries = let
    hide = {
      type = "Application";
      name = ""; 
      noDisplay = true;
    };
  in {
    micro = hide;
    nsnake = hide;
    qt5ct = hide;
    qt6ct = hide;
    rofi = hide;
    rofi-theme-selector = hide;
    xterm = hide;
  };
}
