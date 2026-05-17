{ pkgs, lib, ... }:
{
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "josi" ];
  };
}
