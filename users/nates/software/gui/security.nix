{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    age
    ssh-to-age
    unstable.proton-pass
  ];
}
