{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    # neovim itself is built in ../cli/nvim.nix (wrapped with precompiled
    # treesitter grammars on packpath) - don't add it here too, it'll
    # collide with that wrapped derivation over bin/nvim.
    unstable.zed-editor
    nixd   # nix language server
    micro
    obsidian
  ];
}
