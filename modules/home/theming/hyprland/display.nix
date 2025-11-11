{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
      
    monitor = [
      "DP-2,1280x1024@60,0x0,1"
      "HDMI-A-1,1920x1080@60,1280x0,1"
      "eDP-1,1920x1080@60,3200x0,1.2"
      ];

    workspace = [
      "1,monitor:eDP-1,default:true"
      "2,monitor:HDMI-A-1"
      "3,monitor:DP-2"
      ];
  };
}
