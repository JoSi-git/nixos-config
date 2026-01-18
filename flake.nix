{
  description = "JoSi's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixcord = {
    url = "github:kaylorben/nixcord";
    };
    
    nur.url = "github:nix-community/NUR";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs =
    { nixpkgs, self, ... }@inputs:
    let
      username = "josi";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs username system; host = "desktop"; };
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/desktop
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord ];
          }
         ];
        };
        
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs username system; host = "laptop"; };
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/laptop
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord ];
          }
         ];
        };
        
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs username system; host = "vm"; };
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/vm
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord ];
          }
         ];
        };
      };
    };
}
