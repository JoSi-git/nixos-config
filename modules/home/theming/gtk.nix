{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-color-emoji
    papirus-icon-theme
    nordzy-cursor-theme
  ];

  gtk = {
    enable = true;

#    font = {
#      name = "JetBrains Mono Nerd Font";
#      size = 12;
#   };

    iconTheme = {
      name = "Papirus-Dark";
    };

    cursorTheme = {
      name = "Nordzy-hyprcursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Nordzy-hyprcursors";
    XCURSOR_SIZE = "22";
    
    HYPRCURSOR_THEME = "Nordzy-hyprcursors";
    HYPRCURSOR_SIZE = "22";
  };
}
