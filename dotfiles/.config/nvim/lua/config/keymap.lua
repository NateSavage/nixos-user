-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- quick quit
vim.keymap.set("n", "q", ":q<CR>", { noremap = true, silent = true })

-- shift selected lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- shift selected lines left (ctrl by tabs, shift by spaces, alt shifts to line start
vim.keymap.set("v", "H", ":s/^ // <CR>:nohl<CR>gv")
vim.keymap.set("v", "<C-h>", ":s/^[\\t]\\| \\{1,2}//<CR>:nohl<CR>gv")
vim.keymap.set("v", "<A-h>", ":s/^[\\t+]\\| \\+//<CR>:nohl<CR>gv")
-- shift selected lines right (crtl by tabs, shift by spaces)
vim.keymap.set("v", "<C-l>", ":'<,'> normal! I\t<Esc> v gv")
vim.keymap.set("v", "L", ":'<,'> normal! I <Esc> v gv")

-- scroll screen left/right in 5 character increments
vim.keymap.set('n', '<A-h>', 'zhzhzhzhzh', { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', 'zlzlzlzlzl', { noremap = true, silent = true })

vim.keymap.set('n', '<A-k>', '<C-u>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', '<C-d>', { noremap = true, silent = true })


vim.keymap.set("n", "<leader>rn", ":IncRename ")

-- shift+space, ctrl+space, and alt+space as the _ character in insert mode
-- not all terminals recognize shift + space as a different input from just spacebar
vim.keymap.set('i', '<S-Space>', '_', { noremap = true })
vim.keymap.set('i', '<C-Space>', '_', { noremap = true })
vim.keymap.set('i', '<A-Space>', '_', { noremap = true })

-- gv reselects previously selected text
-- = aligns text to tab boundaries
-- <CR> simulates hitting the enter key
-- v enters visual mode
-- I inserts the following character
-- normal! enters normal editing mode
-- :nohl<CR> clears selected highlighting
-- :s substitutes using a regex expression
