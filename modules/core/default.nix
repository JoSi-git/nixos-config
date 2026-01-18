{inputs, pkgs, username, self, host, ...}: {
  imports = [
    ./better-control.nix   
    ./bootloader.nix
    ./docker.nix
    # # # # # # # # ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./nvidia.nix
    ./nh.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./steam.nix
    ./system.nix
    ./flatpak.nix
    ./user.nix
    ./wayland.nix
  ];
}
