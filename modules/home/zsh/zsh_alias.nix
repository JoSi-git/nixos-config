{
  hostname,
  config,
  pkgs,
  host,
  ...
}:
{
  programs.zsh = {
    shellAliases = {
      # Utils
      tt = "gtrash put";
      cat = "bat";
      nano = "micro";
      diff = "delta --diff-so-fancy --side-by-side";
      less = "bat";
      py = "python";
      icat = "kitten icat";
      dsize = "du -hs";
      pdf = "tdf";
      open = "xdg-open";
      space = "ncdu";

      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";

      # Nixos
      cdnix = "cd ~/nixos-config";
      nix-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#${"\$"}{HOST}";
      nix-update = "(cd ~/nixos-config && nix flake update)";
      nix-clean = "sudo nix-collect-garbage -d; sudo nix-store --gc";
      nix-search = "nix search nixpkgs";
      nix-test = "sudo nixos-rebuild test --flake ~/nixos-config#${"\$"}{HOST}";

      # python
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate";
    };
  };
}




