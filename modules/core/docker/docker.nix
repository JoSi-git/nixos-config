{ pkgs, lib, username, ... }:

{
  virtualisation.docker.enable = true;

  users.users.${username}.extraGroups = [
    "docker"
    "libvirtd"
    "networkmanager"
    "wheel" 
  ];

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}

