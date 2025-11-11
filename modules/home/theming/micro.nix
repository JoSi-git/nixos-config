{ pkgs, lib, ... }:
{
  programs.micro = {
    enable = true;

    settings = {
      "colorscheme" = lib.mkForce "klugheim";
      "*.nix" = { "tabsize" = 2; };
      "*.ml"  = { "tabsize" = 2; };
      "*.asm" = { "tabsize" = 2; };
      "ft:asm" = { "commenttype" = "; %s"; };
      "makefile" = { "tabstospaces" = false; };
      "tabstospaces" = true;
      "tabsize" = 4;
      "mkparents" = true;
      "colorcolumn" = 80;
    };
  };

  xdg.configFile."micro/bindings.json".text = ''
    {
      "Ctrl-Up": "CursorUp,CursorUp,CursorUp,CursorUp,CursorUp",
      "Ctrl-Down": "CursorDown,CursorDown,CursorDown,CursorDown,CursorDown",
      "Ctrl-Backspace": "DeleteWordLeft",
      "Ctrl-Delete": "DeleteWordRight",
      "CtrlShiftUp": "ScrollUp,ScrollUp,ScrollUp,ScrollUp,ScrollUp",
      "CtrlShiftDown": "ScrollDown,ScrollDown,ScrollDown,ScrollDown,ScrollDown"
    }
  '';

  xdg.configFile."micro/colorschemes/klugheim.micro".text = ''
    # Klugheim Theme for Micro (based on Dracula + Klugheim palette)
    color-link default              "#E2E4E3"
    color-link comment              "#1E2832"
    color-link symbol               "#FF79C6"
    color-link constant             "#BD93F9"
    color-link constant.string      "#50FA7B"
    color-link constant.string.char "#50FA7B"
    color-link identifier           "#8BE9FD"
    color-link statement            "#FF5555"
    color-link preproc              "#F1FA8C"
    color-link type                 "#69FF94"
    color-link special              "#FF92DF"
    color-link underlined           "underline #D6ACFF"
    color-link error                "#FF6E6E"
    color-link hlsearch             "#0B1119,#FFFFA5"
    color-link diff-added           "#50FA7B"
    color-link diff-modified        "#F1FA8C"
    color-link diff-deleted         "#FF5555"
    color-link gutter-error         "#FF6E6E"
    color-link gutter-warning       "#F1FA8C"
    color-link line-number          "#1E2832"
    color-link current-line-number  "#8BE9FD"
    color-link cursor-line          "#2C363F"
    color-link color-column         "#15222B"
    color-link statusline           "#E2E4E3,#2C363F"
    color-link tabbar               "#E2E4E3,#15222B"
    color-link todo                 "#FFFFA5"
  '';
}

