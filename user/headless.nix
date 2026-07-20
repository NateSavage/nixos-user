{ ... }: {
  imports = [
    ./server.nix
    ../modules/wsl-usb.nix
  ];

  # modules/wsl-usb.nix self-activates (usbip-yubikey-attach.service) on any
  # WSL machine via wsl.enable, with no toggle needed anywhere else in this
  # repo. In practice it fails to attach reliably (WSL/usbipd-win rough
  # edge - see that file's header for what it's trying to do), so it's
  # turned off explicitly here. Only headless.nix imports this module at
  # all - desktop.nix and a bare server.nix never reference it, WSL or not.
  users.nates.wslUsb.enable = false;

  # Same as server.nix. YubiKey support (SSH resident-key linking, PAM u2f)
  # used to be enabled here for headless/WSL machines, but on this WSL setup
  # usbip-yubikey-attach.service above fails to actually attach the key over
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
}
