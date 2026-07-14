{
  description = "Nate's user configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: let
    flakeLib = import ./lib { lib = nixpkgs.lib; };
    # Overlays that expose pkgs.stable and pkgs.unstable in any module
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
  in {

    lib = flakeLib;

    nixosModules = {
      desktop = {
        imports = [
          { nixpkgs.overlays = [ stableOverlay unstableOverlay ]; }
          ./user/desktop.nix
        ];
      };
      server = {
        imports = [
          { nixpkgs.overlays = [ stableOverlay unstableOverlay ]; }
          ./user/server.nix
        ];
      };
      headless = {
        imports = [
          { nixpkgs.overlays = [ stableOverlay unstableOverlay ]; }
          ./user/headless.nix
        ];
      };
    };

  };
}
