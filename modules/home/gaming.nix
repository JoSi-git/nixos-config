 { pkgs, config, inputs, ...}:
{
  home.packages = with pkgs; [
    ## Utils
    gamemode
    winetricks
    wineWowPackages.wayland
    lutris
    heroic
    headsetcontrol
    prismlauncher
    
    ## Libaries
    sdl3
  ];

} 
