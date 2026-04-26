{ pkgs, config, inputs, ...}:
{
  home.packages = with pkgs; [
    ## Utils
    gamemode
    winetricks
    wineWow64Packages.wayland

    # TEMPORARY FIX (2026-04-25): openldap 2.6.13 tests fail during build, blocking Lutris via dependency chain.
    # Workaround intercepts buildFHSEnv to override openldap with doCheck = false inside the FHS environment only.
    # https://github.com/NixOS/nixpkgs/issues/513245
    (pkgs.lutris.override {
      buildFHSEnv = args: pkgs.buildFHSEnv (args // {
        multiPkgs = envPkgs:
          let
            originalPkgs = args.multiPkgs envPkgs;
            customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
          in
          builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
      });
    })

    heroic
    headsetcontrol
    prismlauncher

    ## Libaries
    sdl3
  ];
}
