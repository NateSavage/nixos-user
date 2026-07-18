{
  description = "Nate's user configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    nvim-config = {
      url = "github:NateSavage/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, nvim-config, ... }: let
    flakeLib = import ./lib { lib = nixpkgs.lib; };
    stableOverlay = final: prev: {
      stable = import nixpkgs {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };

    allOverlays = [ stableOverlay unstableOverlay ];
  in {

    lib = flakeLib;

    nixosModules = {
      desktop = {
        imports = [
          { nixpkgs.overlays = allOverlays; }
          nvim-config.nixosModule
          ./user/desktop.nix
        ];
      };
      server = {
        imports = [
          { nixpkgs.overlays = allOverlays; }
          nvim-config.nixosModule
          ./user/server.nix
        ];
      };
      headless = {
        imports = [
          { nixpkgs.overlays = allOverlays; }
          nvim-config.nixosModule
          ./user/headless.nix
        ];
      };
    };

  };
}
