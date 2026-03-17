{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    unstable.firefox
    onlyoffice-desktopeditors
  ];
}
