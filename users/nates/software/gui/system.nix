{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    mission-center
    fsearch
    bleachbit
  ];
}
