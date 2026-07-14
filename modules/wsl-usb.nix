# modules/wsl-usb.nix
#
# USB/IP passthrough for a YubiKey (or any single USB device) on NixOS-WSL,
# matched by vendor ID rather than a fixed bus ID, so it keeps working
# across different USB ports and different machines.
#
# Self-activating: enable defaults to tracking `wsl.enable`, so a WSL
# machine gets this for free and a non-WSL machine never touches it - no
# `users.nates.wslUsb.enable = true;` needed anywhere.
#
# For that to actually be zero-touch across the whole repo, add this file
# to the `imports` list in user/default.nix (the base both desktop.nix and
# server.nix build on), instead of importing it per-machine.
# Then any consuming flake just needs:
#   imports = [
#     nixos-wsl.nixosModules.default
#     nixos-user.nixosModules.server   # or .desktop
#   ];
#   wsl.enable = true;
# ...and this module activates on its own. `vendorId` still defaults to
# Yubico (1050) but can be overridden per-machine if needed.
#
# One-time per machine, from inside WSL:
#   systemctl start wsl-usbip-bootstrap.service
# This installs usbipd-win on Windows if it's missing, and binds/shares
# the device. It will prompt for one admin approval on the Windows side.
#
# After that, usbip-yubikey-attach.service (plus its timer) keeps the
# device attached automatically, including after replug or reboot.
#
# This module only owns the USB/IP transport - once attached, the device
# shows up as a normal USB device and modules/yubikey.nix's existing udev
# rule (ATTR{idVendor}=="1050") picks it up the same way it would on bare
# metal. That module isn't auto-enabled here - set it explicitly on
# whichever machine flake needs it, same as user/desktop.nix already does:
#   yubikey = {
#     enable = true;
#     user = "nates";
#     identifiers = { a = 31114443; c = 27429156; };
#   };
# user/server.nix doesn't turn this on by default, so a WSL machine built
# on the server module needs that block added explicitly.

{ config, lib, pkgs, ... }:

let
  cfg = config.users.nates.wslUsb;
in
{
  options.users.nates.wslUsb = {
    enable = lib.mkOption {
      type = lib.types.bool;
      # Auto-activate on WSL, stay off everywhere else. "or false" matters
      # here: on a plain desktop/server machine, nixos-wsl's module was
      # never imported, so the `wsl` option namespace doesn't exist at all -
      # without the fallback this would hard-crash evaluation instead of
      # just being false.
      default = config.wsl.enable or false;
      defaultText = lib.literalExpression "config.wsl.enable or false";
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

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = config.wsl.enable or false;
      message = "users.nates.wslUsb.enable is set, but wsl.enable is not - this only works on NixOS-WSL.";
    }];

    # Base USB/IP client support from NixOS-WSL: installs linuxPackages.usbip,
    # enables udev. We deliberately don't use its autoAttach list, since that
    # wants a fixed busid - ours is discovered dynamically below instead.
    wsl.usbip.enable = true;

    # usbutils (lsusb) for debugging the attach. Packages/udev rules for
    # the key itself (yubikey-manager, yubikey-personalization) come from
    # modules/yubikey.nix when that's enabled - not duplicated here.
    environment.systemPackages = [ pkgs.usbutils ];

    # Finds a shared USB device by vendor ID and attaches it. Exits 0 (not
    # failed) when nothing is found yet - that's the normal state before
    # the key is plugged in and shared from Windows.
    systemd.services.usbip-yubikey-attach = {
      description = "Attach YubiKey over USB/IP by vendor ID";
      after = [ "network.target" ];
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ iproute2 gnugrep gnused linuxPackages.usbip ];
      script = ''
        set -euo pipefail

        WINIP="$(ip route list | sed -nE 's/(default)? via ([0-9.]+) dev eth0.*/\2/p' | head -n1)"
        if [ -z "$WINIP" ]; then
          echo "usbip-yubikey-attach: couldn't determine Windows host IP" >&2
          exit 0
        fi

        BUSID="$(usbip list --remote="$WINIP" 2>/dev/null \
          | grep -E '\(${cfg.vendorId}:' \
          | sed -E 's/^[[:space:]]*([0-9]+-[0-9.]+):.*/\1/' \
          | head -n1)"
        if [ -z "$BUSID" ]; then
          echo "usbip-yubikey-attach: no device with vendor ${cfg.vendorId} shared from $WINIP" >&2
          exit 0
        fi

        usbip attach --remote="$WINIP" --busid="$BUSID" || true
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

    # One-time, per-machine Windows-side setup. Deliberately NOT started
    # automatically - installing software and the bind step need an
    # elevation (UAC) prompt, which needs a live interactive Windows
    # session to render. Trigger it yourself after setting up a new
    # machine:
    #   systemctl start wsl-usbip-bootstrap.service
    systemd.services.wsl-usbip-bootstrap = {
      description = "One-time Windows-side setup for YubiKey USB/IP sharing";
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ gnugrep gawk ];
      script = ''
        set -euo pipefail
        PS="powershell.exe -NoProfile -NonInteractive -Command"

        if ! $PS "Get-Command usbipd -ErrorAction SilentlyContinue" >/dev/null 2>&1; then
          echo "Installing usbipd-win..."
          $PS "winget install --id dorssel.usbipd -e --accept-source-agreements --accept-package-agreements"
        fi

        echo "Looking for a device with vendor ${cfg.vendorId}..."
        BUSID="$($PS "usbipd list" | grep -i "${cfg.vendorId}:" | awk '{print $1}' | head -n1)"
        if [ -z "$BUSID" ]; then
          echo "No device with vendor ${cfg.vendorId} found - is it plugged in?" >&2
          exit 1
        fi

        echo "Binding busid $BUSID (approve the admin prompt on Windows)..."
        $PS "Start-Process usbipd -ArgumentList 'bind','--busid=$BUSID' -Verb RunAs -Wait"

        echo "Done. usbip-yubikey-attach.service will pick it up within 45s,"
        echo "or run: systemctl start usbip-yubikey-attach.service"
      '';
    };
  };
}
