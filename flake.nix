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
    
    hyprland.url = "github:hyprwm/Hyprland";
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
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
          inherit system;
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/desktop
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord
            ];
          }
          ];
          specialArgs = {
            host = "desktop";
            inherit self inputs username system;
          };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/laptop
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord
            ];
          }
          ];
          specialArgs = {
            host = "laptop";
            inherit self inputs username system;
          };
        };
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/vm
          {
            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord
            ];
          }
          ];
          specialArgs = {
            host = "vm";
            inherit self inputs username system;
          };
        };
      };
    };
}
