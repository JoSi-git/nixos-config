{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ rofi ];

  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
  xdg.configFile."rofi/bluetooth-menu.rasi".source = ./bluetooth-menu.rasi;
  xdg.configFile."rofi/power-menu.rasi".source = ./power-menu.rasi;
  xdg.configFile."rofi/wifi-menu.rasi".source = ./wifi-menu.rasi;
  
}

