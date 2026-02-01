{inputs, username, host, ...}: {
  imports = [
    inputs.stylix.homeModules.default
    ./browser.nix                  # configuration for all browsers
    ./fastfetch                    # fastfetch configuration
    ./gaming.nix                   # packages related to gaming
    ./gnome.nix                    # gnome apps
    ./gtk.nix                      # gtk theme
    ./hyprland                     # window manager
    ./kitty.nix                    # terminal
#   ./modrinth.nix                # minecraft game launcher
    ./nemo.nix                     # file manager
#   ./nixcord.nix
    ./packages.nix                 # other packages    
    ./quickshell                   # replacement for waybar
    ./rofi                         # launcher
    ./scripts/scripts.nix          # personal scripts
    ./spicetify.nix                # custom spotify client
    ./stylix.nix                   # nixos alternative to classic gtk theming
    ./sway                         # notification center + widgets
    ./waypaper.nix                 # GUI wallpaper picker
    ./winboat.nix                  # run windows apps on linux
    ./xdg-mimes.nix                # xdg config
    ./zsh                          # shell
  ];
}
