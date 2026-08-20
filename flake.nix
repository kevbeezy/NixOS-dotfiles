{
  description = "System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-blur = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nvf.url = "github:notashelf/nvf";
    areofyl-fetch.url = "github:areofyl/fetch";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.joachim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # This passes your inputs into your configuration.nix
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          ./configuration.nix
          { home-manager.sharedModules = [ inputs.nvf.homeManagerModules.default ]; }
        ];
      };

      homeConfigurations."joachim" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Adjust architecture if needed
        modules = [
          ./home.nix
          inputs.nvf.homeManagerModules.default
        ];
      };
    };
}
