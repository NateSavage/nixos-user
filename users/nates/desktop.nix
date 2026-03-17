{ pkgs, ... }: {
  imports = [
    ./default.nix
    ./software/cli
    ./software/gui
  ];

  # COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  yubikey.lockOnRemove = true;
  users.nates.openssh = true;

  # AppImage support
  environment.systemPackages = [ pkgs.appimage-run ];
  programs.appimage.binfmt = true;

  # LocalSend for local file transfer
  programs.localsend.enable = true;
  programs.localsend.openFirewall = true;

  # Flatpak with Flathub
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # nh (nix helper) requires these
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nh.enable = true;
  programs.git.enable = true;

}
