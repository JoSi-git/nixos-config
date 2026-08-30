{ pkgs, ... }:
{
  # vulkan-validation-layers tries to git clone deps at build time which breaks in the Nix sandbox
  nixpkgs.overlays = [
    (final: prev: {
      vulkan-validation-layers = prev.vulkan-validation-layers.overrideAttrs (old: {
        cmakeFlags = [ "-DUPDATE_DEPS=OFF" ] ++ (old.cmakeFlags or []);
      });
    })
  ];

  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamescope = {
      enable = true;
      capSysNice = false;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
