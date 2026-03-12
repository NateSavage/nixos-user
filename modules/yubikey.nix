{ config, pkgs, lib, ... }:
let
  homeDirectory = "/home/nates";

  yubikeyIds = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") config.yubikey.identifiers
  );

  # Symlinks ~/.ssh/id_yubikey to the key matching whichever yubikey is plugged in
  yubikey-up = pkgs.writeShellApplication {
    name = "yubikey-up";
    runtimeInputs = with pkgs; [ gawk yubikey-manager ];
    text = ''
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
        echo "WARNING: Unidentified yubikey with serial $serial. Won't link an SSH key."
        exit 0
      fi

      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk" "${homeDirectory}/.ssh/id_yubikey"
      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk.pub" "${homeDirectory}/.ssh/id_yubikey.pub"
    '';
  };

  yubikey-down = pkgs.writeShellApplication {
    name = "yubikey-down";
    text = ''
      rm -f "${homeDirectory}/.ssh/id_yubikey"
      rm -f "${homeDirectory}/.ssh/id_yubikey.pub"
    '';
  };
in {
  options.yubikey = {
    enable = lib.mkEnableOption "yubikey support";
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

  config = lib.mkIf config.yubikey.enable {
    environment.systemPackages = with pkgs; [
      yubikey-manager
      pam_u2f
      yubikey-up
      yubikey-down
    ];

    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.yubikey-agent.enable = true;

    services.udev.extraRules = ''
      # Link ~/.ssh/id_yubikey to the plugged-in key
      SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"
      SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico Yubi*", RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"
    '' + lib.optionalString config.yubikey.lockOnRemove ''
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
