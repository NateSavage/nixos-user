{ lib, config, ... }: let
  cfg = config.users.nates;
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  dotfilesDir = ../../dotfiles;

  # Recursively list files relative to a directory
  listFilesRelative = dir:
    let
      entries = builtins.readDir dir;
    in lib.lists.flatten (lib.attrsets.mapAttrsToList (name: type:
      if type == "regular" then [ name ]
      else if type == "directory" then map (f: "${name}/${f}") (listFilesRelative "${dir}/${name}")
      else []
    ) entries);

  # One tmpfiles symlink rule per dotfile
  dotfileRules = map (relPath:
    "L /home/nates/${relPath} - - - - ${dotfilesDir}/${relPath}"
  ) (listFilesRelative dotfilesDir);
in {

  imports = [ ../../modules/yubikey.nix ];

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
          "the-claw"

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

    yubikey = {
      enable = true;
      identifiers = {
        a = 31114443;
        c = 27429156;
      };
    };

    services.openssh = lib.mkIf cfg.openssh {
      enable = true;
      settings = {
        AllowUsers = [ "nates" ];
        # Override with services.openssh.settings.PasswordAuthentication = true;
        PasswordAuthentication = lib.mkDefault false;
      };
    };

    systemd.tmpfiles.rules = dotfileRules ++ [
      "d /home/nates/.ssh/sockets 0700 nates users -"
    ];
  };
}
