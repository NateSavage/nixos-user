{ pkgs, ... }: {
  imports = [
    ./default.nix
    ./software/cli
  ];

  users.nates.openssh = true;

  # modules/wsl-usb.nix self-activates (usbip-yubikey-attach.service) on any
  # WSL machine via wsl.enable, with no toggle needed anywhere else in this
  # repo. In practice it fails to attach reliably (WSL/usbipd-win rough
  # edge - see that file's header for what it's trying to do), so it's
  # turned off explicitly here for server.nix and headless.nix (which
  # imports this). desktop.nix is unaffected - it's bare metal, so
  # wsl.enable is never set there and this module never activates regardless.
  users.nates.wslUsb.enable = false;

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
