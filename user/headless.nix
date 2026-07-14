{ ... }: {
  # Same as server.nix, plus YubiKey support (SSH resident-key linking,
  # PAM u2f for login/sudo) - for headless machines you still want the
  # key working on, e.g. a WSL box.
  imports = [
    ./server.nix
  ];

  yubikey = {
    enable = true;
    user = "nates";
    identifiers = {
      a = 31114443;
      c = 27429156;
    };
    # lockOnRemove intentionally left at its default (false) - that's meant
    # for a physical desktop session, not a headless/SSH-only machine.
  };
}
