{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    unstable.neovim
    unstable.zed-editor
    nixd   # nix language server
    micro
    obsidian
  ];
}
