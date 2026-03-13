return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    build = ":TSUpdate",
    config = function ()
        local TS = require("nvim-treesitter")
        if not TS.get_installed then
            -- LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
            return
        end

        LazyVim.treesitter.ensure_treesitter_cli(function()
            TS.update(nil, { summary = true })
        end)

        vim.cmd([[
            highlight! link @class_name_statement.name Type
        ]])

        --local configs = require("nvim-treesitter.configs")

        --configs.setup({
        --    sync_install = false,
        --})
    end,
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    event = { "VeryLazy" },
    opts_extend = { "ensure_installed" },
    opts = {
        indent = { enable = true },
        highlight = { enable = true },
        folds = { enable = true },
        ensure_installed = {
              "lua", "odin", "python", "rust", "sql",
	          "c", "cpp", "c_sharp",
	          "gdscript", "gdshader",
	          "bash", "just", "nix"
  	    },
    }
 }
