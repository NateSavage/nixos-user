---@type vim.lsp.Config
return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'astro.config.mjs', 'astro.config.ts', '.git' },
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib',
    },
  },
}
