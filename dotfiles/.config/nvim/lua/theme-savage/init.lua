local M = {}

function M.setup()
    vim.o.background = 'dark'
    vim.g.colors_name = 'savage'

    local util = require("theme-savage.util")
    local theme = require("theme-savage.theme")
    vim.api.nvim_set_hl(0, 'Statement', { bold = false })
    util.load(theme)
end

return M
