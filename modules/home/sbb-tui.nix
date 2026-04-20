{ pkgs, ... }:
{
  home.packages = [
    (pkgs.buildGoModule rec {
      pname = "sbb-tui";
      version = "master";

      src = pkgs.fetchFromGitHub {
        owner = "necrom4";
        repo = "sbb-tui";
        rev = "master";
        hash = "sha256-y8rshbAi9Uy//8ZeGu79YHV9R49BEODHBV1wNRd0t7Y=";
      };
      vendorHash = "sha256-dUr3Rrn90TMj+fjGTfAUGecOlrln4bw3+Ymtmv2rTxY=";
      proxyVendor = true; 
      doCheck = false;
    })
  ];
}
