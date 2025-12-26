{ config, pkgs, ... }:
{
  programs.nixcord = {
    enable = true;

    discord = {
      vencord.enable = true;
      # equicord.enable = true;
    };
    
    quickCss = ''
      /* JoSi QuickCSS-Code */
      :root {
        --nixcord-accent-color: #7289da;
      }
    '';

    config = {
      useQuickCss = true;
      frameless = true;
      
      plugins = {
      # Custom Plugin COnfig
      };
    };
  };
}
