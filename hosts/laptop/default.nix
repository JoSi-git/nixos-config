{ pkgs, config, ... }: {

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };
  
  imports = [  
    ./hardware-configuration.nix
    ../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
    asusctl
    python3
  ];
  
  programs._1password.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "josi" ];
  };
  
  services = {
    power-profiles-daemon.enable = true;

    asusd.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    tlp.settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];
  };

  systemd.services.setKbdLight = {
    description = "Set Keyboard Backlight to Static White using asusctl aura";
    after = [ "multi-user.target" "asusd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.asusctl}/bin/asusctl aura static -c ffffff
      '';
      RemainAfterExit = true;
    };
  };
}

