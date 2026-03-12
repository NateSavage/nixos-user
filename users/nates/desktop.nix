{ pkgs, ... }: {
  imports = [ ./default.nix ];

  # COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  yubikey.lockOnRemove = true;

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

  users.users.nates.packages = with pkgs; [
    # editors
    unstable.neovim
    unstable.zed-editor
    nixd            # nix language server
    micro

    # browsers
    unstable.firefox

    # nix tools
    nix-inspect
    deadnix

    # key management
    age
    ssh-to-age

    # dev
    just
    git
    git-lfs
    unstable.godot_4
    unstable.godot_4-export-templates-bin

    # desktop tools
    mission-center
    fsearch
    bleachbit
    yubioath-flutter

    # productivity
    onlyoffice-desktopeditors
    obsidian

    # creative
    unstable.blender

    # misc
    github-desktop
    unstable.proton-pass
  ];
}
