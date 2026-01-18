{ pkgs, ... }:
let
  wall-change = pkgs.writeShellScriptBin "wall-change" (
    builtins.readFile ./wall-change.sh
  );
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (
    builtins.readFile ./wallpaper-picker.sh
  );

  runbg = pkgs.writeShellScriptBin "runbg" (
    builtins.readFile ./runbg.sh
  );

  toggle_blur = pkgs.writeShellScriptBin "toggle_blur" (
    builtins.readFile ./toggle_blur.sh
  );
  toggle_oppacity = pkgs.writeShellScriptBin "toggle_oppacity" (
    builtins.readFile ./toggle_oppacity.sh
  );
  toggle_float = pkgs.writeShellScriptBin "toggle_float" (
    builtins.readFile ./toggle_float.sh
  );

  maxfetch = pkgs.writeShellScriptBin "maxfetch" (
    builtins.readFile ./maxfetch.sh
  );

  compress = pkgs.writeShellScriptBin "compress" (
    builtins.readFile ./compress.sh
  );
  extract = pkgs.writeShellScriptBin "extract" (
    builtins.readFile ./extract.sh
  );

  show-keybinds = pkgs.writeShellScriptBin "show-keybinds" (
    builtins.readFile ./keybinds.sh
  );

  ascii = pkgs.writeShellScriptBin "ascii" (
    builtins.readFile ./ascii.sh
  );

  record = pkgs.writeShellScriptBin "record" (
    builtins.readFile ./record.sh
  );

  screenshot = pkgs.writeShellScriptBin "screenshot" (
    builtins.readFile ./screenshot.sh
  );

  toogle-nitch = pkgs.writeShellScriptBin "toggle-nitch" (
    builtins.readFile ./toggle-nitch.sh
  );
in
{
  home.packages = with pkgs; [
    wall-change
    wallpaper-picker
    runbg
    toggle_blur
    toggle_oppacity
    toggle_float
    maxfetch
    compress
    extract
    show-keybinds
    ascii
    record
    screenshot
    toogle-nitch
  ];
}

