return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "td",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "ts",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "tr",
      "<cmd>Trouble lsp toggle focus=true win.position=top<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
  },
}
