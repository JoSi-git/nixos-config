{ config, pkgs, ... }:
{
  hardware.enableAllFirmware = true;

  fileSystems."/home/josi/Games" = {
    device = "UUID=f24e4b85-02ac-4ec8-81de-e222a446b679";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=15s" ];
  };
}

