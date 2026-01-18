{ pkgs, host, lib, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = lib.mkForce "JetBrains Mono Nerd Font";
      size = lib.mkForce (if host == "laptop" then 15 else 16);
    };

    settings = {
      confirm_os_window_close = 0;
      background_opacity = lib.mkForce "0.66";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 60;
      window_padding_width = if host == "laptop" then 5 else 10;

      tab_title_template = "{index}";
      active_tab_font_style = "normal";
      inactive_tab_font_style = "normal";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      active_tab_foreground = "#E2E4E3";
      active_tab_background = "#2C363F";
      inactive_tab_foreground = "#E2E4E3";
      inactive_tab_background = "#15222B";

      background = "#0B1119";
      foreground = "#E2E4E3";
      selection_background = "#2C363F";
      selection_foreground = "#E2E4E3";
      cursor = "#F8F8F2";
      cursor_text_color = "#0B1119";
      url_color = "#8BE9FD";

      color0  = "#0B1119"; # black
      color1  = "#FF5555"; # red
      color2  = "#50FA7B"; # green
      color3  = "#F1FA8C"; # yellow
      color4  = "#BD93F9"; # blue
      color5  = "#FF79C6"; # magenta
      color6  = "#8BE9FD"; # cyan
      color7  = "#E2E4E3"; # white

      color8  = "#1E2832"; # bright black
      color9  = "#FF6E6E"; # bright red
      color10 = "#69FF94"; # bright green
      color11 = "#FFFFA5"; # bright yellow
      color12 = "#D6ACFF"; # bright blue
      color13 = "#FF92DF"; # bright magenta
      color14 = "#A4FFFF"; # bright cyan
      color15 = "#FFFFFF"; # bright white
    };

    keybindings = {
      # Tabs
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";

      # Unbind default split tab keys
      "ctrl+shift+left" = "no_op";
      "ctrl+shift+right" = "no_op";
    };
  };
}

