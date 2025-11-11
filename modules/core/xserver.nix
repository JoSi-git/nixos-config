{ pkgs, username, ... }:
{
  services = {
    xserver = {
      enable = true;
        xkb.layout = "ch";
        xkb.variant = "de";
    };

    displayManager.autoLogin = {
      enable = true;
      user = "${username}";
    };
    libinput = {
      enable = true;
    };
  };
  # To prevent getting stuck at shutdown
  # systemd.settings.Manager = "DefaultTimeoutStopSec=10s";
}
