{ pkgs, ... }: {
  users.users.nates.packages = with pkgs.stable; [
    nix-inspect
    deadnix
  ];
}
