{ pkgs, ... }: {
  imports = [
    ./default.nix
    ./software/cli
  ];

  users.nates.openssh = true;

  # nh (nix helper) requires these
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nh.enable = true;
  programs.git.enable = true;

}
