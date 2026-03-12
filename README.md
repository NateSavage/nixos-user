# nixos-user

A NixOS flake that defines the `nates` user account for any machine. Import it into a machine flake to get the full user setup — account, groups, SSH authorized keys, yubikey, packages, and dotfiles.

## Usage

Add this flake as an input in your machine flake:

```nix
inputs.nixos-user = {
  url = "github:NateSavages/nixos-user";  # or path:/path/to/nixos-user
  inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";  # optional: share unstable pin
};
```

Then import the appropriate module for the machine type:

```nix
# Desktop / laptop
imports = [ inputs.nixos-user.nixosModules.nate-desktop ];

# Server / headless
imports = [ inputs.nixos-user.nixosModules.nate-server ];
```

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `users.nates.wheel` | bool | `true` | Grant nates sudo (wheel) access |

Example — disable sudo on a server:
```nix
imports = [ inputs.nixos-user.nixosModules.nate-server ];
users.nates.wheel = false;
```

## Dotfiles

Files in `dotfiles/` are automatically symlinked into `/home/nates/` on every `nixos-rebuild switch`, mirroring the directory structure. For example:

```
dotfiles/.gitconfig        → /home/nates/.gitconfig
dotfiles/.ssh/config       → /home/nates/.ssh/config
dotfiles/.config/foo/bar   → /home/nates/.config/foo/bar
```

Just drop a file in and rebuild — no Nix changes needed.

## SSH

Authentication is yubikey-only (password auth disabled by default). Two hardware keys are registered:

- `a-ed25519-sk.pub` — yubikey A
- `c-ed25519-sk.pub` — yubikey C

SSH ControlMaster is configured so each host only needs one yubikey touch per 10-minute window, shared across all connections including `git push`, `scp`, etc.

To re-enable password auth on a specific machine:
```nix
services.openssh.settings.PasswordAuthentication = true;
```

## Adding a New SSH Key

Drop a `.pub` file into `users/nates/keys/`. It will be picked up automatically on next `nixos-rebuild`.

## Directory Structure

```
flake.nix
dotfiles/               # symlinked into /home/nates/ on rebuild
  .gitconfig
  .ssh/
    config
users/nates/
  default.nix           # base: account, groups, SSH keys, yubikey, dotfiles, SSH hardening
  desktop.nix           # base + desktop packages
  server.nix            # base + server/terminal packages
  keys/                 # SSH public keys added to authorized_keys
    a-ed25519-sk.pub
    c-ed25519-sk.pub
```
