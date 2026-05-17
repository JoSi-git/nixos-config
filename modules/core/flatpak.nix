{ inputs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "io.github.nozwock.Packet"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
      "io.github.nozwock.Packet" = {
        # Allow access to home directory so files from any location can be sent
        Context.filesystems = [ "home" ];
      };
    };
  };
}
