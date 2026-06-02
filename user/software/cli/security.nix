{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.age
    stable.ssh-to-age
  ];
}
