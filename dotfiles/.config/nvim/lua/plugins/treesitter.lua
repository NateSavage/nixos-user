return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    build = ":TSUpdate",
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        vim.cmd([[highlight! link @class_name_statement.name Type]])

        -- nvim-treesitter sometimes passes invalid TSNodes to get_node_text during
        -- injection processing; node:range() crashes on them even though node ~= nil
        local orig_get_node_text = vim.treesitter.get_node_text
        vim.treesitter.get_node_text = function(node, ...)
            if node == nil then return '' end
            local ok, result = pcall(orig_get_node_text, node, ...)
            return ok and result or ''
        end

        -- restart treesitter highlighting if a crash killed it
        vim.api.nvim_create_autocmd('BufEnter', {
            callback = function(ev)
                local buf = ev.buf
                if vim.bo[buf].buftype ~= '' then return end
                if not vim.treesitter.highlighter.active[buf] then
                    pcall(vim.treesitter.start, buf)
                end
            end,
        })

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
	          "bash", "just", "nix",
	          "html", "css",
  	    },
    }
 }
