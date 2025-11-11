{inputs, username, host, ...}: {
  imports = [
    ./gaming.nix                     # packages related to gaming
    ./nemo.nix                        # file manager
#    ./modrinth.nix                   # minecraft game launcher
    ./scripts/nixy.nix               # scripts menu
    ./packages.nix                  # other packages
    ./scripts/scripts.nix           # personal scripts
    ./theming                          # config files related to desktop theming
    ./winboat.nix                     # run windows apps on linux
    ./xdg-mimes.nix                # xdg config
    ./zsh                                  # shell
  ];
}
