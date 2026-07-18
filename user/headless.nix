{ ... }: {
  # Same as server.nix. YubiKey support (SSH resident-key linking, PAM u2f)
  # used to be enabled here for headless/WSL machines, but on this WSL setup
  # usbip-yubikey-attach.service (modules/wsl-usb.nix, auto-enabled via
  # wsl.enable - see server.nix) fails to actually attach the key over
  # USB/IP in practice, which makes modules/yubikey.nix's udev-triggered
  # linking moot anyway - the device never shows up. Disabled here rather
  # than removed, in case usbipd-win/WSL's USB/IP support gets more reliable
  # later:
  #
  # yubikey = {
  #   enable = true;
  #   user = "nates";
  #   identifiers = {
  #     a = 31114443;
  #     c = 27429156;
  #   };
  # };
  imports = [
    ./server.nix
  ];
}
