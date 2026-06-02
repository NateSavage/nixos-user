{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    spotify
  ];
}
