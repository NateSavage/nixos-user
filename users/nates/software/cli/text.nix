{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    micro
    unstable.neovim
  ];
}
