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
  
outputs = { nixpkgs, ... }@inputs:
    let
      username = "josi";
      platform = "x86_64-linux";
      
      nixpkgsSettings = {
        nixpkgs.hostPlatform = platform;
        nixpkgs.config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };
        nixpkgs.overlays = [ inputs.nur.overlays.default ];
      };
      
      sharedModules = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ inputs.nixcord.homeModules.nixcord ];
        }
        inputs.stylix.nixosModules.stylix
      ];
    in
    {
      nixosConfigurations = {
        lc-josi-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username; host = "lc-josi-01"; };
          modules = [ nixpkgsSettings ] ++ sharedModules ++ [ ./hosts/desktop ];
        };

        ln-josi-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username; host = "ln-josi-01"; };
          modules = [ nixpkgsSettings ] ++ sharedModules ++ [ ./hosts/laptop ];
        };

        srv-josi-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username; host = "srv-josi-01"; };
          modules = [ nixpkgsSettings ] ++ sharedModules ++ [ ./hosts/vm ];
        };
      };
    };
}
