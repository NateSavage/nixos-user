{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.micro
    unstable.neovim
  ];
}
