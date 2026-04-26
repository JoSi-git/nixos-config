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
        hash = "sha256-JLjAhs5UbqgNYqpA3cDucrAS6ell+0JiDJNf7G33Nhs=";
      };
      vendorHash = "sha256-dUr3Rrn90TMj+fjGTfAUGecOlrln4bw3+Ymtmv2rTxY=";
      proxyVendor = true; 
      doCheck = false;
    })
  ];
}
