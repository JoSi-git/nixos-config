{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME,Nordzy-hyprcursors"
        "HYPRCURSOR_SIZE,22"
        "XCURSOR_THEME,Nordzy-cursors"
        "XCURSOR_SIZE,22"
      ];
      
      input = {
        kb_layout = "ch";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 0;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(E2E4E3)";
        "col.inactive_border" = lib.mkForce "0x00000000";
        # border_part_of_window = false;
        # no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = false;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        middle_click_paste = false;
      };

      dwindle = {
        force_split = 2;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
      };

      decoration = {
        rounding = 5;
        # active_opacity = 0.90;
        # inactive_opacity = 0.90;
        # fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };

        shadow = {
          enabled = true;

          offset = "0 2";
          range = 20;
          render_power = 3;
          color = lib.mkForce "rgba(00000055)";
        };
      };

      xwayland = {
        force_zero_scaling = true;
      };
   };
}
