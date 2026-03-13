
-- Set default root markers for all clients
--vim.lsp.config('*', {
--  root_markers = { '.git' },
--})

vim.lsp.enable('lua')
vim.lsp.enable('roslyn')
vim.lsp.enable('gdscript')
--vim.lsp.enable('gdshader')
-- Source - https://stackoverflow.com/a

vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- global settings when an LSP is available
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      -- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.definition) then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.declaration) then
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
    end

  end,
})

-- Diagnostics
-- diagnositc levels are ERROR, WARN, INFO, and HINT
vim.diagnostic.config({
    underline = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            --[vim.diagnositc.severity.INFO] = '', -- warn and info don't seem to have assignable signs yet
            --[vim.diagnositc.severity.HINT] = ''
        },
    },

    -- display hits, info, and warnings underneath a line only when the line is selected
    virtual_lines = {
        current_line = true,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        }
    },

    -- display error messages inline always
    --[[
    virtual_text = {
        severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
        }
    },
    --]]
})
