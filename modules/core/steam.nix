{ pkgs, lib, ... }:
{
 
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamescope = {
      enable = true;
      capSysNice = false;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
