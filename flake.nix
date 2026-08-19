{
  description = "System Flake Configuration";

  inputs = {
    # The standard NixOS packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # The Zen Browser community flake
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # The custom KWin blur effect
    kwin-blur = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      # If using stable 24.05, use: url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
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
        ];
      };

      homeConfigurations."joachim" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux; # Adjust architecture if needed
    modules = [ ./home.nix ];
  };
    };
}
