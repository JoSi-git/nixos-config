{ inputs, ... }: {
  imports = [
    ./display.nix
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
