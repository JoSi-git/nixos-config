{ pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-color-emoji
    papirus-icon-theme
    nordzy-cursor-theme
    
    (runCommand "alfa-slab-one" {} ''
      mkdir -p $out/share/fonts/truetype
      cp ${./fonts}/AlfaSlabOne-Regular.ttf $out/share/fonts/truetype/
    '')
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
    size = 22;
    
    hyprcursor.enable = true;
    hyprcursor.size = 22;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };

  home.sessionVariables = {
    HYPRCURSOR_THEME = lib.mkForce "Nordzy-hyprcursors";
    HYPRCURSOR_SIZE = lib.mkForce 22;
    
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE = 22;
  };
}
