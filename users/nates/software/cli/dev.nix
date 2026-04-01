{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    dotnetCorePackages.sdk_9_0_1xx
    git
    git-lfs
    just
  ];
}
