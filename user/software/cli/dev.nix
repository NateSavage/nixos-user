{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.dotnetCorePackages.dotnet-sdk_10
    stable.git
    stable.git-lfs
    stable.just
  ];
}
