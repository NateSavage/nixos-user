vim.filetype.add({
    extension = { csproj = "csproj" },
})

vim.opt.number = true

-- no swapefiles
vim.opt.swapfile = false

-- don't display line numbers on the left edge of the screen
vim.opt.nu = false
vim.opt.relativenumber = false

vim.opt.showtabline = 2

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})

-- gdscript is whitespace-sensitive and requires real tabs
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gdscript" },
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = false
    end,
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = '0'

vim.opt.colorcolumn = "121" --"+1" -- highlight column after text width
--vim.opt.textwidth = 120
vim.opt.wrap = false
vim.opt.linebreak = true

-- long running undo files
--vim.opt.swapfile = false
--vim.opt.backup = false
--vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
--vim.opt.undofile = true

-- incremental search filter feedback
vim.opt.incsearch = true

-- case insensitive search by default
vim.opt.ignorecase = true
-- override ignorecase if search pattern contains uppercase letters
vim.opt.smartcase = true

-- tell vim our terminal supports more colors
vim.opt.termguicolors = true

-- number of characters to retain on screen when scrolling up and down
vim.opt.scrolloff = 8

-- milliseconds before swap buffer is automatically written, and time to wait for command holds
vim.opt.updatetime = 50
