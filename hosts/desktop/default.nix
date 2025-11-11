{ pkgs, ... }:{
    
    nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };
  
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
