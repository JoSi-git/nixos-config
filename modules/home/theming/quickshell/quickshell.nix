{ config, pkgs, lib,... }: 

let
  configName = "default";

  shellAssets = ./config;
  
in 
{
  programs.quickshell = {
    enable = true;
    
    package = pkgs.quickshell; 

    configs = {
      ${configName} = shellAssets; 
    };
    activeConfig = configName;
  };
}
