{ pkgs, ... }:
let
  # Grammars matching the language set from lua/config/treesitter.lua.
  # Nix builds and compiles these so nvim-treesitter never has to shell out
  # to a C compiler or hit the network at runtime.
  treesitterGrammars = pkgs.unstable.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    lua
    odin
    python
    rust
    sql
    c
    cpp
    c_sharp
    gdscript
    gdshader
    bash
    just
    nix
    html
    css
  ]);

  # Wrapped neovim whose only job beyond the base editor is to put
  # precompiled, Nix-built plugins on &packpath as "start" packages so
  # lazy.nvim never has to download/build them itself. All actual editor
  # configuration (lazy.nvim, keymaps, LSP, etc.) still lives in
  # dotfiles/.config/nvim - see lua/config/lazy.lua (reset_packpath = false
  # + packloadall) and lua/config/treesitter.lua.
  nvim = pkgs.unstable.wrapNeovimUnstable pkgs.unstable.neovim-unwrapped (
    pkgs.unstable.neovimUtils.makeNeovimConfig {
      plugins = [ treesitterGrammars ];
    }
  );
in {
  # Packages required by dotfiles/.config/nvim that aren't managed by
  # nvim's own plugin manager (lazy.nvim) or by Mason inside nvim.
  users.users.nates.packages = with pkgs; [
    nvim

    # Mason (lua/plugins/mason.lua) installs html-lsp, css-lsp, and
    # astro-language-server via npm - it needs node/npm in PATH to do so.
    stable.nodejs

    # lsp/nix.lua calls `nixpkgs-fmt` as the nix LSP's formatting command.
    stable.nixpkgs-fmt

    # lsp/roslyn.lua (wired up in lua/config/lsp.lua) shells out to
    # `csharp-ls` for C#. It isn't in Mason's ensure_installed list, so it
    # needs to come from here.
    stable.csharp-ls

    # lsp/crystalline.lua expects a `crystalline` binary on PATH. It isn't
    # packaged in nixpkgs, so it has to be built by hand with the Crystal
    # compiler + shards: `shards build` from
    # https://github.com/elbywan/crystalline
    stable.crystal
    stable.shards

    # fff.nvim (lua/plugins/fff.lua) downloads a prebuilt binary or falls
    # back to building from source with rustup/cargo; blink.cmp
    # (lua/plugins/blink.lua) can optionally be built from source too.
    # Prebuilt binaries often don't run on NixOS without nix-ld, so keep a
    # toolchain around to build from source instead.
    stable.cargo
    stable.rustc

    # UI icons (lualine, telescope, blink.cmp's nerd_font_variant) expect a
    # Nerd Font. Matches the font already used in dotfiles/.config/zed.
    stable.nerd-fonts._0xproto

    # nvim-treesitter parsers ship precompiled via `nvim` above now, but
    # gcc is kept as a general-purpose fallback C compiler (e.g. for any
    # plugin that still tries to build something at runtime).
    stable.gcc
  ];
}
