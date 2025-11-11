{ pkgs, config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    evdi
  ];

  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    displaylink
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

