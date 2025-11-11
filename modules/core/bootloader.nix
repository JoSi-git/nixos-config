{pkgs, lib, ...}: {
  boot = {
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 10;
      };
    };
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_zen;
    
    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

     plymouth = {
       enable = true;
       theme = lib.mkForce "connect";
       themePackages = with pkgs; [
         (adi1090x-plymouth-themes.override {
           selected_themes = ["connect"];
         })
       ];
     };
  };

  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = { DefaultTimeoutStopSec = "10s"; };
}
