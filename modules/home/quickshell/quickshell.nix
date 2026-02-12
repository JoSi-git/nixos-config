{ config, pkgs, lib, ... }:

let
  localConfigDir = "${config.home.homeDirectory}/nixos-config/modules/home/quickshell/config";
in
{
  home.file.".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink localConfigDir; 
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
  };
  home.packages = [
    pkgs.qt6.qtwayland
  ];
}


