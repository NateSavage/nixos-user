{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.zig # we use this as our C compiler
    stable.dotnet-sdk_10
    stable.git
    stable.git-lfs
    stable.just
  ];
}
