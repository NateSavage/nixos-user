{
  description = "Nate's user configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
  };

  outputs = { self, nixpkgs-unstable, nixos-cosmic, ... }: let
    # Overlay that exposes pkgs.unstable for use in any module
    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit (prev) system;
        config.allowUnfree = true;
      };
    };
  in {

    # NixOS modules for importing into machine flakes.
    # Usage: imports = [ inputs.nixos-user.nixosModules.nate-desktop ];
    # Use pkgs.unstable.<name> in user package lists for unstable packages.
    nixosModules = {
      nate-desktop = { imports = [
        { nixpkgs.overlays = [ unstableOverlay ]; }
        nixos-cosmic.nixosModules.default
        ./users/nates/desktop.nix
      ]; };
      nate-server = { imports = [
        { nixpkgs.overlays = [ unstableOverlay ]; }
        ./users/nates/server.nix
      ]; };
    };

  };
}
