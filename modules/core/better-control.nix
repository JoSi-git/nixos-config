{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    better-control
  ];
}

