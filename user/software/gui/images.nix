{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    unstable.krita
  ];
}
