{ config, pkgs, lib,... }: 

let
  configName = "default";

  shellAssets = builtins.path { 
    path =./config; 
  };
  
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
