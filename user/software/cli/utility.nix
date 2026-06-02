{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.yazi
  ];

}
