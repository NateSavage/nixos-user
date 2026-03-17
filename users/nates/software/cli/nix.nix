{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    nix-inspect
    deadnix
  ];
}
