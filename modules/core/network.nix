{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    firewall = {
      enable = false;
      allowedTCPPorts = [ 22 80 443 59010 59011 ];
      allowedUDPPorts = [ 59010 59011 ];
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
   
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
