{ config, pkgs, ... }:

let
  customStyle = builtins.replaceStrings 
    ["@HOME@"] 
    ["${config.home.homeDirectory}"] 
    (builtins.readFile ./style.css);
in
{
  programs.wlogout = {
    enable = true;
    style = customStyle;
    layout = [
      { label = "lock"; action = "hyprlock"; text = "Lock"; keybind = "l"; }
      { label = "logout"; action = "loginctl terminate-user $USER"; text = "Logout"; keybind = "e"; }
      { label = "reboot"; action = "systemctl reboot"; text = "Reboot"; keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Shutdown"; keybind = "s"; }
    ];
  };

  xdg.configFile."wlogout/icons".source = ./icons;
}
