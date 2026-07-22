{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.zig # we use this as our C compiler
    stable.dotnet-sdk_10
    stable.ripgrep
    stable.git
    stable.git-lfs
    stabe.lazygit
    stable.just
  ];
}
