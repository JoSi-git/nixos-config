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
}
