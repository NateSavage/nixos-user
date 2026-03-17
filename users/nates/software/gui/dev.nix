{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    git
    git-lfs
    just
    github-desktop
  ];
}
