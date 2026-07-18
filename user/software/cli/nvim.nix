{ ... }: {
  # Neovim itself - plugins/tooling built via Nix, config live-cloned to
  # ~/.config/nvim - is fully handled by github:NateSavage/nvim's own
  # nixosModules.default (imported in ../../../flake.nix's nixosModules).
  # This just turns it on for this user. See that repo's flake.nix and
  # nix/module.nix for what actually happens under the hood (overlay,
  # package install, auto-clone activation script).
  programs.nates-nvim = {
    enable = true;
    user = "nates";
  };
}
