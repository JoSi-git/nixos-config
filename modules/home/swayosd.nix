{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [ swayosd ];

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [ "swayosd-server" ];

      bind = [ ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle" ];
      bindl = [
        ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise 5%+"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 0%"
      ];
      bindle = [
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume +2 --max-volume=100"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume -2"
        "$mainMod, f11, exec, swayosd-client --output-volume +2 --max-volume=100"
        "$mainMod, f12, exec, swayosd-client --output-volume -2"
      ];
      bindr = [
        "CAPS,Caps_Lock,exec,swayosd-client --caps-lock"
        ",Scroll_Lock,exec,swayosd-client --scroll-lock"
        ",Num_Lock,exec,swayosd-client --num-lock"
      ];
    };
  };

  xdg.configFile."swayosd/style.css".text = ''
    * {
      font-family: monospace;
      font-weight: bold;
      font-size: 15pt;
      color: #E2E4E3;
    }

    window {
      padding: 0px 10px;
      border-radius: 25px;
      border: 10px;
      background: alpha(#0B1119, 0.99);
    }

    #container {
      margin: 15px;
    }

    progressbar:disabled,
    image:disabled {
      opacity: 0.95;
    }

    progressbar {
      min-height: 6px;
      border-radius: 999px;
      background: transparent;
      border: none;
    }

    trough {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: alpha(#E2E4E3, 0.2);
    }

    progress {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: #E2E4E3;
    }
  '';
}

