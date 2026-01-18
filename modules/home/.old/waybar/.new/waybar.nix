{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
  };

  home.packages = with pkgs; [
    jetbrains-mono
    bluetui
    pamixer
  ];

  home.file.".config/waybar/config.jsonc".source = ./config.jsonc;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/theme.css".source = ./theme.css;
  home.file.".config/waybar/scripts".source = ./scripts;

  #home.file.".config/rofi".source = ./rofi;
}

