{ lib, config, ... }: let
  cfg = config.users.nates;
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  dotfilesDir = ../dotfiles;

  # Recursively list files relative to a directory
  listFilesRelative = dir:
    let
      entries = builtins.readDir dir;
    in lib.lists.flatten (lib.attrsets.mapAttrsToList (name: type:
      if type == "regular" then [ name ]
      else if type == "directory" then map (f: "${name}/${f}") (listFilesRelative "${dir}/${name}")
      else []
    ) entries);

  # Recursively list directories relative to a directory
  listDirsRelative = dir:
    let
      entries = builtins.readDir dir;
    in lib.lists.flatten (lib.attrsets.mapAttrsToList (name: type:
      if type == "directory" then
        [ name ] ++ map (f: "${name}/${f}") (listDirsRelative "${dir}/${name}")
      else []
    ) entries);

  # d rules ensure parent dirs exist before C rules copy files in
  dotfileDirRules = map (relDir:
    "d /home/nates/${relDir} - nates users -"
  ) (listDirsRelative dotfilesDir);

  # One tmpfiles copy rule per dotfile. C copies a real, writable file into
  # place (editable live, unlike an L symlink into the read-only Nix store),
  # but only when the destination is absent -- so `dotfiles-load` deletes the
  # existing copies first to refresh them from the repo.
  dotfileRules = map (relPath:
    "C /home/nates/${relPath} 0644 nates users - ${dotfilesDir}/${relPath}"
  ) (listFilesRelative dotfilesDir);
in {

  imports = [
    ../modules/yubikey.nix
    ../modules/smb-mounts.nix
    ../modules/wsl-usb.nix
  ];

  options.users.nates = {
    wheel = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Grant nates sudo (wheel) access.";
    };
    openssh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the OpenSSH daemon and restrict it to nates.";
    };
  };

  config = {
    users.users.nates = {
      isNormalUser = true;

      hashedPassword = "$y$j9T$6cS0mWQUxcTw8jakUq5Vm.$3wvWAPuitCmAFTbLhPlabXVDT9BOwFanB7BbPedtF68";
      extraGroups = ifGroupsExist (
        lib.optional cfg.wheel "wheel"
        ++ [
          "home"
          "localclaw"

          "synced"
          "panopticom"
          "panopticom-website"
          "heliograph"
          "eromancer"
          "future-way-designs"

          "anyone"
        ]
      );

      # Placed into /etc/ssh/authorized_keys.d/nates on NixOS
      openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ./keys;
    };

    smb-mounts = {
      enable = true;
      mounts = map (share: {
        device = "//nox.lan/${share}";
        mountPoint = "/mnt/nox/${share}";
        credentialsFile = "/etc/smb-credentials-nox";
      }) [ "public" "archive" "eromancer" "panopticom" ];
    };

    services.openssh = lib.mkIf cfg.openssh {
      enable = true;
      settings = {
        AllowUsers = [ "nates" ];
        # Override with services.openssh.settings.PasswordAuthentication = true;
        PasswordAuthentication = lib.mkDefault false;
      };
    };

    # add github and gitlab to system-wide known_hosts file
    programs.ssh.knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    };

    systemd.tmpfiles.rules = dotfileDirRules ++ dotfileRules ++ [
      "d /home/nates/.ssh/sockets 0700 nates users -"
      "L /home/nates/.ssh/a-ed25519-sk.pub - nates users - ${./keys/a-ed25519-sk.pub}"
      "L /home/nates/.ssh/c-ed25519-sk.pub - nates users - ${./keys/c-ed25519-sk.pub}"
    ];
  };
}
