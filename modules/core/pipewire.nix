{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 2048;
        default.clock.min-quantum = 512;
        default.clock.max-quantum = 8192;
      };
    };
  };
  hardware.alsa.enablePersistence = true;
  services.udev.packages = [ pkgs.headsetcontrol ];
  environment.systemPackages = with pkgs; [ 
    pavucontrol
    headsetcontrol
  ];
}
