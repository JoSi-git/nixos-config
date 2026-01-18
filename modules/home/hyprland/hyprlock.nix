{ pkgs, host, ... }:
let
  text = "rgb(226, 228, 227)";
in
{
  home.packages = [
    pkgs.hyprlock
    pkgs.inter
  ];
  
  xdg.configFile."hypr/hyprlock.conf".text = ''
  # BACKGROUND
  background {
    monitor =
    path = ~/Pictures/wallpapers/wallpaper.png
    blur_passes = 2
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
  }
  
  # GENERAL
  general {
    no_fade_in = false
    grace = 0
    disable_loading_bar = false
  }
  
  # Hour-Time
  label {
    monitor = eDP-1
    text = cmd[update:1000] echo -e "$(date +"%H")"
    color = rgba(255, 185, 0, .6)
    font_size = 190
    font_family = alfaslabone 
    position = 0, 300
    halign = center
    valign = center
  }

  # Minute-Time
  label {
    monitor = eDP-1
    text = cmd[update:1000] echo -e "$(date +"%M")"
    color = rgba(255, 255, 255, .6)
    font_size = 190
    font_family = alfaslabone
    position = 0, 75
    halign = center
    valign = center
  }

  # Day-Date-Month
  label {
    monitor = eDP-1
    text = cmd[update:1000] echo "<span color='##ffffff99'>$(date '+%A, ')</span><span color='##ffb90099'>$(date '+%d %B')</span>"
    font_size = 25
    font_family = Inter
    position = 0, -80
    halign = center
    valign = center
  }

  # USER
  label {
    monitor = eDP-1
    text =   $USER
    color = rgba(216, 222, 233, 0.80)
    outline_thickness = 2
    dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    font_size = 20
    font_family = JetBrains Mono Nerd
    position = 0, -300
    halign = center
    valign = center
  }
  
  # INPUT FIELD
  input-field {
    monitor = eDP-1
    size = 250, 45
    outline_thickness = 1
    dots_size = 0.1
    dots_spacing = 0.1
    dots_center = true
    dots_text_format = <span> </span>
    outer_color = rgba(0, 0, 0, 0)
    inner_color = rgba(255, 255, 255, 0.1)
    font_color = rgb(200, 200, 200)
    fade_on_empty = false
    font_family = JetBrainsMono Nerd Font = <i><span foreground="##ffffff99"> 󰌾 Enter Pass</span></i>
    hide_input = false
    position = 0, -360
    halign = center
    valign = center
    }

  # CURRENT SONG
  label {
    monitor = eDP-1
    text = cmd[update:1000] echo "$(~/nixos-config/modules/home/scripts/songdetail.sh)" 
    color = rgba(255, 255, 255, 0.7)
    font_size = 18
    font_family = Inter Bold
    position = 0, 80
    halign = center
    valign = bottom
  }
  '';
}
