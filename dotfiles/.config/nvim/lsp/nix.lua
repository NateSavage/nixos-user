---@type vim.lsp.Config
return {
  cmd = { 'nil', '--stdio' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', 'default.nix' },
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixpkgs-fmt' },
      },
    },
  },
}
