{ config, pkgs, ... }:
{
  hardware.enableAllFirmware = true;

  fileSystems."/home/josi/Games" = {
    device = "UUID=61cd1dd8-88ab-41d6-ab13-eee34cde0923";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=15s" ];
  };
}

