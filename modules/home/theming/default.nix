{inputs, username, host, ...}: {
  imports = [
    inputs.stylix.homeModules.default
    ./browser.nix                      # configuration for all browsers
    ./gtk.nix                             # gtk theme
    ./gnome.nix                       # gnome apps
    ./hyprland                          # window manager
    ./micro.nix                         # nano replacement
    ./kitty.nix                           # terminal
    ./quickshell                        # replacement for waybar
    ./rofi                                  # launcher
    ./spicetify.nix                     # custom spotify client
    ./sway                               # notification center + widgets
    ./stylix.nix                         # nixos alternative to classic gtk theming
    ./waypaper.nix                  # GUI wallpaper picker
    ./waybar                           # bar for hyperland
  ];
}




