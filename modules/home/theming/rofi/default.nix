{ inputs, ... }:
{
  imports = [
    ./rofi.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
