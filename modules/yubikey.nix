{ config, pkgs, lib, ... }:
let
  cfg = config.yubikey;
  homeDirectory = "/home/${cfg.user}";

  yubikeyIds = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") cfg.identifiers
  );

  # Symlinks ~/.ssh/id_yubikey to the key matching whichever yubikey is plugged in,
  # downloading the resident key from the yubikey first if we haven't seen it before.
  yubikey-up = pkgs.writeShellApplication {
    name = "yubikey-up";
    runtimeInputs = with pkgs; [ gawk yubikey-manager openssh util-linux libnotify ];
    text = ''
      notify() {
        local msg="$1"
        logger -t yubikey "$msg"
        local uid
        uid=$(id -u ${cfg.user})
        runuser -u ${cfg.user} -- \
          env DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
          notify-send --app-name="YubiKey" "YubiKey" "$msg" 2>/dev/null || true
      }

      serial=$(ykman list | awk '{print $NF}')
      if [ -z "$serial" ]; then
        exit 0
      fi

      declare -A serials=(${yubikeyIds})

      key_name=""
      for key in "''${!serials[@]}"; do
        if [[ $serial == "''${serials[$key]}" ]]; then
          key_name="$key"
        fi
      done

      if [ -z "$key_name" ]; then
        notify "Unidentified YubiKey plugged in (serial: $serial) — no SSH key linked"
        exit 0
      fi

      notify "YubiKey '$key_name' plugged in"

      # First time seeing this yubikey on this machine — download its resident key
      if [ ! -f "${homeDirectory}/.ssh/$key_name-ed25519-sk" ]; then
        notify "Extracting resident key for '$key_name' from YubiKey..."
        tmp=$(mktemp -d)
        chown ${cfg.user}:users "$tmp"
        runuser -u ${cfg.user} -- sh -c "cd '$tmp' && ssh-keygen -K"
        for f in "$tmp"/id_ed25519_sk_rk*; do
          [ -f "$f" ] || continue
          if [[ "$f" == *.pub ]]; then
            dest="${homeDirectory}/.ssh/$key_name-ed25519-sk.pub"
          else
            dest="${homeDirectory}/.ssh/$key_name-ed25519-sk"
          fi
          mv "$f" "$dest"
          chown ${cfg.user}:users "$dest"
          [[ "$dest" != *.pub ]] && chmod 600 "$dest"
        done
        rm -rf "$tmp"
        notify "Resident key for '$key_name' saved to ~/.ssh/"
      fi

      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk" "${homeDirectory}/.ssh/id_yubikey"
      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk.pub" "${homeDirectory}/.ssh/id_yubikey.pub"
      notify "SSH identity linked to '$key_name'"
    '';
  };

  yubikey-down = pkgs.writeShellApplication {
    name = "yubikey-down";
    runtimeInputs = with pkgs; [ util-linux libnotify ];
    text = ''
      rm -f "${homeDirectory}/.ssh/id_yubikey"
      rm -f "${homeDirectory}/.ssh/id_yubikey.pub"
      msg="YubiKey unplugged, SSH identity unlinked"
      logger -t yubikey "$msg"
      uid=$(id -u ${cfg.user})
      runuser -u ${cfg.user} -- \
        env DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
        notify-send --app-name="YubiKey" "YubiKey" "$msg" 2>/dev/null || true
    '';
  };
in {
  options.yubikey = {
    enable = lib.mkEnableOption "yubikey support";
    user = lib.mkOption {
      type = lib.types.str;
      description = "User to link the YubiKey SSH identity for.";
    };
    identifiers = lib.mkOption {
      default = {};
      type = lib.types.attrsOf lib.types.int;
      description = "Attrset of yubikey serial numbers keyed by name.";
    };
    lockOnRemove = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Lock the session when a yubikey is unplugged.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-manager
      pam_u2f
      yubikey-up
      yubikey-down
    ];

    services.udev.packages = [ pkgs.yubikey-personalization ];

    services.udev.extraRules = ''
      # Link ~/.ssh/id_yubikey to the plugged-in key
      SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"
      SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico Yubi*", RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"
    '' + lib.optionalString cfg.lockOnRemove ''
      # Lock the session when yubikey is unplugged
      SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico YubiKey OTP+FIDO+CCID", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    security.pam.sshAgentAuth.enable = true;
    security.pam.u2f = {
      enable = true;
      settings = {
        cue = true;
        authFile = "${homeDirectory}/.config/Yubico/u2f_keys";
      };
    };
    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      sudo.sshAgentAuth = true;
    };
  };
}
