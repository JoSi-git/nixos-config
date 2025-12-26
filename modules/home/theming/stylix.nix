{lib, pkgs, config, ... }: {
  config.stylix = {
    enable = true;
    polarity = "dark";
    
    targets.spicetify.enable = false;
    targets.waybar.enable = false;
    
    targets.firefox.enable = true;
    targets.firefox.profileNames = [ "default" ];
    
    
    # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
    base16Scheme = {
      base00 = "#0B1119"; # Default Background
      base01 = "#1c1e1f"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "#1c1e1f"; # Selection Background
      base03 = "#c0c0c0"; # Comments, Invisibles, Line Highlighting
      base04 = "#f5e0dc"; # Dark Foreground (Used for status bars)
      base05 = "#FFFFFF"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "#f5e0dc"; # Light Foreground (Not often used)
      base07 = "#b4befe"; # Light Background (Not often used)
      
      base08 = "#f8cd4c"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "#f95d5d"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "#2999fa"; # Classes, Markup Bold, Search Text Background
      base0B = "#6bfe6b"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "#ff80ce"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "#2999fa"; # Functions, Methods, AttriCbute IDs, Headings, Accent color
      base0E = "#be5feb"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "#e7e7e7"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      name = "Nordzy-hyprcursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
     };
   };
}
