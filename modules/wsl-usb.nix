# modules/wsl-usb.nix
{ config, lib, pkgs, options, ... }:

let
  cfg = config.users.nates.wslUsb;
  wslPresent = options ? wsl.usbip.enable;
in
{
  options.users.nates.wslUsb = {
    enable = lib.mkOption {
      type = lib.types.bool;
      # Auto-activate on WSL, stay off everywhere else. wslPresent matters
      # as much as `wsl.enable` does here: on a plain desktop/server
      # machine, nixos-wsl's module was never imported, so the `wsl` option
      # namespace doesn't exist at all - without both checks this would
      # hard-crash evaluation instead of just being false.
      default = wslPresent && (config.wsl.enable or false);
      defaultText = lib.literalExpression "wslPresent && (config.wsl.enable or false)";
      description = ''
        Whether to enable USB/IP passthrough for a YubiKey on NixOS-WSL.
        Defaults to tracking `wsl.enable`, so this needs no manual toggle
        on WSL machines. Set explicitly to override either direction.
      '';
    };

    vendorId = lib.mkOption {
      type = lib.types.str;
      default = "1050"; # Yubico
      description = "USB vendor ID (hex, no 0x prefix) to look for when attaching over USB/IP.";
    };
  };

  config = lib.mkIf cfg.enable ({
    assertions = [{
      assertion = wslPresent && (config.wsl.enable or false);
      message = "users.nates.wslUsb.enable is set, but wsl.enable is not, or NixOS-WSL's module isn't imported - this only works on NixOS-WSL.";
    }];

    # The kernel module that actually makes USB/IP attach possible on the
    # client side. Not guaranteed to auto-load on WSL - this makes sure it
    # does at boot via systemd-modules-load.service. If `modprobe vhci-hcd`
    # fails manually, this kernel doesn't have USB/IP client support
    # compiled in at all, which needs a custom WSL2 kernel, not a config fix.
    boot.kernelModules = [ "vhci-hcd" ];

    # usbutils (lsusb) for debugging the attach. Packages/udev rules for
    # the key itself (yubikey-manager, yubikey-personalization) come from
    # modules/yubikey.nix when that's enabled - not duplicated here.
    environment.systemPackages = [ pkgs.usbutils ];

    # Finds a shared USB device by vendor ID and attaches it. Exits 0 (not
    # failed) when nothing is found yet - that's the normal state before
    # the key is plugged in and shared from Windows.
    systemd.services.usbip-yubikey-attach = {
      description = "Attach YubiKey over USB/IP by vendor ID";
      after = [ "systemd-modules-load.service" "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        # Backstop in case something else unexpectedly blocks - the timeout
        # calls below should make this a non-issue on their own.
        TimeoutStartSec = "15s";
      };
      path = with pkgs; [ iproute2 gnugrep gnused linuxPackages.usbip kmod coreutils systemd ];
      script = ''
        set -euo pipefail

        modprobe vhci-hcd 2>/dev/null || echo "usbip-yubikey-attach: modprobe vhci-hcd failed" >&2

        # WSL doesn't reliably coldplug-trigger already-loaded kernel devices
        # into udev's database, which is what usbip's vhci_hcd lookup depends
        # on (see nix-community/NixOS-WSL#241 and many similar reports
        # against usbipd-win with the same "udev_device_new_from_subsystem_
        # sysname failed" error). Force it explicitly rather than assuming
        # services.udev.enable alone gets there in time.
        udevadm trigger || true
        udevadm settle --timeout=5 || true

        WINIP="$(ip route list | sed -nE 's/(default)? via ([0-9.]+) dev eth0.*/\2/p' | head -n1)"
        if [ -z "$WINIP" ]; then
          echo "usbip-yubikey-attach: couldn't determine Windows host IP" >&2
          exit 0
        fi

        # timeout here matters: if nothing's listening on the Windows side
        # yet (usbipd-win not installed/sharing), an unreachable connect
        # attempt can hang far longer than this service - and this service
        # blocks `nixos-rebuild switch` while it runs.
        BUSID="$(timeout 5s usbip list --remote="$WINIP" 2>/dev/null \
          | grep -E '\(${cfg.vendorId}:' \
          | sed -E 's/^[[:space:]]*([0-9]+-[0-9.]+):.*/\1/' \
          | head -n1)"
        if [ -z "$BUSID" ]; then
          echo "usbip-yubikey-attach: no device with vendor ${cfg.vendorId} shared from $WINIP (or timed out reaching it)" >&2
          exit 0
        fi

        timeout 5s usbip attach --remote="$WINIP" --busid="$BUSID" || true
      '';
    };

    # Retry periodically, in case the key gets plugged in after boot, or a
    # replug drops the attach. No RemainAfterExit here on purpose - it needs
    # to actually re-run each tick, not just stay "active (exited)".
    systemd.timers.usbip-yubikey-attach = {
      description = "Retry YubiKey USB/IP attach";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "20s";
        OnUnitActiveSec = "45s";
      };
    };

    # Runs automatically once per machine on first boot (gated by the
    # marker file below, in the same style as server.nix's
    # nates-ssh-keygen). Safe to assume an interactive Windows session
    # exists here for the UAC prompt: a WSL instance only boots because
    # someone launched it from one in the first place. If it fails (e.g.
    # the key isn't plugged in yet), the marker is never written, so it
    # tries again on the next boot instead of going silent forever.
    systemd.services.wsl-usbip-bootstrap = {
      description = "One-time Windows-side setup for YubiKey USB/IP sharing";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      unitConfig.ConditionPathExists = "!/var/lib/wsl-usbip-bootstrap-done";
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ gnugrep gawk coreutils ];
      script = ''
        set -euo pipefail
        # Interactive WSL shells get Windows' PATH appended by WSL's own
        # interop layer, but systemd services don't inherit that, and a
        # freshly-spawned powershell.exe here doesn't pick up PATH changes
        # winget itself just made either. Call Windows binaries by known
        # absolute path instead of relying on PATH resolution at all.
        # Adjust if your automount root or drive letter differs from the
        # WSL default.
        PS="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive -Command"
        USBIPD='C:\Program Files\usbipd-win\usbipd.exe'

        if ! $PS "if (-not (Test-Path '$USBIPD')) { exit 1 }"; then
          echo "Installing usbipd-win..."
          $PS "winget install --id dorssel.usbipd-win -e --accept-source-agreements --accept-package-agreements"
        fi

        echo "Looking for a device with vendor ${cfg.vendorId}..."
        BUSID="$($PS "& '$USBIPD' list" | grep -i "${cfg.vendorId}:" | awk '{print $1}' | head -n1)"
        if [ -z "$BUSID" ]; then
          echo "No device with vendor ${cfg.vendorId} found - is it plugged in? Will retry next boot." >&2
          exit 1
        fi

        echo "Binding busid $BUSID (approve the admin prompt on Windows)..."
        $PS "Start-Process '$USBIPD' -ArgumentList 'bind','--busid=$BUSID' -Verb RunAs -Wait"

        touch /var/lib/wsl-usbip-bootstrap-done

        echo "Done. usbip-yubikey-attach.service will pick it up within 45s,"
        echo "or run: systemctl start usbip-yubikey-attach.service"
      '';
    };
  } // lib.optionalAttrs wslPresent {
    # Base USB/IP client support from NixOS-WSL: installs linuxPackages.usbip,
    # enables udev. We deliberately don't use its autoAttach list, since that
    # wants a fixed busid - ours is discovered dynamically above instead.
    wsl.usbip.enable = true;
  });
}
