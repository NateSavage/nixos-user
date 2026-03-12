{ pkgs, ... }: {
  imports = [ ./default.nix ];

  # nh (nix helper) requires these
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nh.enable = true;
  programs.git.enable = true;

  users.users.nates.packages = with pkgs; [
    unstable.neovim
    git
    git-lfs
    micro

    # nix tools
    nix-inspect
    deadnix

    # key management
    age
    ssh-to-age

    # dev
    just
  ];
}
