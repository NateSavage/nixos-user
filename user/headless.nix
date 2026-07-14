{ ... }: {
  imports = [ ./server.nix ];

  yubikey = {
    enable = true;
    user = "nates";
    identifiers = {
      a = 31114443;
      c = 27429156;
    };
  };
}
