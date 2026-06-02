{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.dotnetCorePackages.sdk_9_0_1xx
    stable.git
    stable.git-lfs
    stable.just
  ];
}
