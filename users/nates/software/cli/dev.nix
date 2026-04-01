{ pkgs, ... }: {
  users.users.nates.packages = with pkgs.stable; [
    dotnetCorePackages.sdk_9_0_1xx
    git
    git-lfs
    just
  ];
}
