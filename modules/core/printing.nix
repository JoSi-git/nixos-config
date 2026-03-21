{ pkgs, username, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      hplip 
      cups-filters 
    ];
  };

 services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
    hplipWithPlugin
  ];
}
