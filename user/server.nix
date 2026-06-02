{ pkgs, ... }: {
  imports = [
    ./default.nix
    ./software/cli
  ];

  users.nates.openssh = true;

  # Copy the host's SSH keypair into nates' .ssh so it can be used for
  # outbound git/SSH auth (e.g. GitHub) without a YubiKey on the server.
  systemd.tmpfiles.rules = [
    "C /home/nates/.ssh/id_server     0600 nates users - /etc/ssh/ssh_host_ed25519_key"
    "C /home/nates/.ssh/id_server.pub 0644 nates users - /etc/ssh/ssh_host_ed25519_key.pub"
  ];

  # nh (nix helper) requires these
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nh.enable = true;
  programs.git.enable = true;

}
