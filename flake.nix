{
  description = "Nate's user configuration.";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: let
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

    # NixOS modules for importing into machine flakes.
    # Usage: imports = [ inputs.nixos-user.nixosModules.nate-desktop ];
    # pkgs.<name> resolves to unstable. Use pkgs.stable.<name> to pin to stable.
    nixosModules = {
      nate-desktop = { imports = [
        { nixpkgs.overlays = [ stableOverlay unstableOverlay ]; }
        ./users/nates/desktop.nix
      ]; };
      nate-server = { imports = [
        { nixpkgs.overlays = [ stableOverlay unstableOverlay ]; }
        ./users/nates/server.nix
      ]; };
    };

  };
}
