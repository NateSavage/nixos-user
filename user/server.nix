{ pkgs, ... }: {
  imports = [
    ./default.nix
    ./software/cli
  ];

  users.nates.openssh = true;

  # Generate a dedicated SSH identity for outbound git/SSH auth (e.g. GitHub).
  # Runs once on first boot; the key persists across rebuilds.
  systemd.services."nates-ssh-keygen" = {
    description = "Generate nates server SSH identity";
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "!/home/nates/.ssh/id_server";
    serviceConfig = {
      Type = "oneshot";
      User = "nates";
      ExecStart = "${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f /home/nates/.ssh/id_server -N \"\" -C \"nates@nox\"";
    };
  };

  # nh (nix helper) requires these
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nh.enable = true;
  programs.git.enable = true;

}
