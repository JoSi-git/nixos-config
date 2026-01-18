{inputs, username, host, ...}: {
  imports = [
    inputs.stylix.homeModules.default
    ./browser.nix                  # configuration for all browsers
    ./gaming.nix                   # packages related to gaming
    ./gnome.nix                    # gnome apps
    ./gtk.nix                      # gtk theme
    ./hyprland                     # window manager
    ./kitty.nix                    # terminal
    ./micro.nix                    # nano replacement
#   ./modrinth.nix                # minecraft game launcher
    ./nemo.nix                     # file manager
    ./nixcord.nix                  # Declarative Vencord plugins + options 
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
