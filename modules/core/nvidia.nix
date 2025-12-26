{ pkgs, config, ...}: 
let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta;
in {
  services.xserver.videoDrivers = ["nvidia"];
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerLevel=0x3;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x3" # Performance/power optimizations
  ];
  boot.blacklistedKernelModules = ["nouveau"];
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    WLR_DRM_NO_ATOMIC = "1";
    NVD_BACKEND = "direct";
    MOZ_ENABLE_WAYLAND = "1";
  };
  
  nixpkgs.config = {
    nvidia.acceptLicense = true;
  };
  
  # Nvidia configuration
  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = true; 
      };
      modesetting.enable = true;
      package = nvidiaDriverChannel;
      forceFullCompositionPipeline = true;

      # Configuration for hybrid AMD+Nvidia laptop
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd =
            true;
        };
        sync.enable = false;
        amdgpuBusId = "PCI:6:0:0"; # Integrated AMD GPU
        nvidiaBusId = "PCI:1:0:0"; # Dedicated Nvidia GPU
      };
    };

    # Enhanced graphics support
    graphics = {
      enable = true;
      package = nvidiaDriverChannel;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
        egl-wayland
        vulkan-loader
        vulkan-validation-layers
        libva
      ];
    };
  };

  # Additional useful packages
  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
    libva-utils
  ];
}
