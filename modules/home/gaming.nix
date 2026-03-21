 { pkgs, config, inputs, ...}:
{
  home.packages = with pkgs; [
    ## Utils
    gamemode
    winetricks
    wineWow64Packages.wayland
    lutris
    heroic
    headsetcontrol
    prismlauncher
    
    ## Libaries
    sdl3
  ];

} 
