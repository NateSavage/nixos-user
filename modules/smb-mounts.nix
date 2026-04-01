{ config, pkgs, lib, ... }:
let
  cfg = config.smb-mounts;

  mountModule = lib.types.submodule {
    options = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "SMB share path, e.g. //server/share";
      };
      mountPoint = lib.mkOption {
        type = lib.types.str;
        description = "Local directory to mount the share at";
      };
      credentialsFile = lib.mkOption {
        type = lib.types.str;
        description = ''
          Path to a credentials file containing:
            username=...
            password=...
          This file must be created manually outside of the Nix config.
        '';
      };
    };
  };
in {
  options.smb-mounts = {
    enable = lib.mkEnableOption "SMB/CIFS mounts";
    mounts = lib.mkOption {
      type = lib.types.listOf mountModule;
      default = [];
      description = "List of SMB shares to mount";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cifs-utils ];

    fileSystems = lib.listToAttrs (map (m: {
      name = m.mountPoint;
      value = {
        device = m.device;
        fsType = "cifs";
        options = [
          "credentials=${m.credentialsFile}"
          "_netdev"
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
        ];
      };
    }) cfg.mounts);
  };
}
