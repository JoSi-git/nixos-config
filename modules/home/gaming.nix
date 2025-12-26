{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    ## Utils
    gamemode
    gamescope
    winetricks
    wineWowPackages.wayland
    lutris
    headsetcontrol
    
    prismlauncher
  ];
}

