{ config, pkgs, lib, ... }:

let
  localConfigDir = "${config.home.homeDirectory}/nixos-config/modules/home/theming/quickshell/config";
in
{
  home.file.".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink localConfigDir;

  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
  };
}
