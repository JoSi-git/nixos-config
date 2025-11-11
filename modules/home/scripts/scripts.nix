{ pkgs, ... }:
let
  wall-change = pkgs.writeShellScriptBin "wall-change" (
    builtins.readFile ./scripts/wall-change.sh
  );
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (
    builtins.readFile ./scripts/wallpaper-picker.sh
  );

  runbg = pkgs.writeShellScriptBin "runbg" (
    builtins.readFile ./scripts/runbg.sh
  );

  toggle_blur = pkgs.writeShellScriptBin "toggle_blur" (
    builtins.readFile ./scripts/toggle_blur.sh
  );
  toggle_oppacity = pkgs.writeShellScriptBin "toggle_oppacity" (
    builtins.readFile ./scripts/toggle_oppacity.sh
  );
  toggle_float = pkgs.writeShellScriptBin "toggle_float" (
    builtins.readFile ./scripts/toggle_float.sh
  );

  maxfetch = pkgs.writeShellScriptBin "maxfetch" (
    builtins.readFile ./scripts/maxfetch.sh
  );

  compress = pkgs.writeShellScriptBin "compress" (
    builtins.readFile ./scripts/compress.sh
  );
  extract = pkgs.writeShellScriptBin "extract" (
    builtins.readFile ./scripts/extract.sh
  );

  show-keybinds = pkgs.writeShellScriptBin "show-keybinds" (
    builtins.readFile ./scripts/keybinds.sh
  );

  ascii = pkgs.writeShellScriptBin "ascii" (
    builtins.readFile ./scripts/ascii.sh
  );

  record = pkgs.writeShellScriptBin "record" (
    builtins.readFile ./scripts/record.sh
  );

  screenshot = pkgs.writeShellScriptBin "screenshot" (
    builtins.readFile ./scripts/screenshot.sh
  );

  toogle-nitch = pkgs.writeShellScriptBin "toggle-nitch" (
    builtins.readFile ./scripts/toggle-nitch.sh
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

