{ pkgs, ... }: {
  imports = [ ./default.nix ];

  users.users.nate.packages = with pkgs; [
    neovim
    git
    git-lfs
    micro
    firefox
    unstable.zed-editor
  ];
}
