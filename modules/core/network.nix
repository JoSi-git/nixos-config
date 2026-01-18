{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    
    firewall = {
      enable = false; 
      allowedTCPPorts = [ 22 80 443 59010 59011 ];
      allowedUDPPorts = [ ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  
  services.blueman.enable = true;
  security.rtkit.enable = true;
}
