return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
        local harpoon = require("harpoon")
        
        -- adds the current file to harpoon index if none is there, travels to it otherwise
        local function UltraHarpoon(index)
          local list = harpoon:list()
          if list.items[index] == nil or list.items[index] == "" then
            list:add()
          else
            list:remove_at(index)
            list:add()
            list:select(index)
          end
        end

	    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
	    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

	    vim.keymap.set("n", "<leader>j", function() harpoon:list().select(1) end)
	    vim.keymap.set("n", "<leader>k", function() harpoon:list().select(2) end)
	    vim.keymap.set("n", "<leader>l", function() harpoon:list().select(3) end)
	    vim.keymap.set("n", "<leader>;", function() harpoon:list().select(4) end)

	    vim.keymap.set("n", "<leader>dj", function() harpoon:list():remove_at(1) end)
	    vim.keymap.set("n", "<leader>dk", function() harpoon:list():remove_at(2) end)
	    vim.keymap.set("n", "<leader>dl", function() harpoon:list():remove_at(3) end)
	    vim.keymap.set("n", "<leader>d;", function() harpoon:list():remove_at(4) end)

	    -- Toggle previous & next buffers stored within Harpoon list
	    vim.keymap.set("n", "<C-M-p>", function() harpoon:list():prev() end)
	    vim.keymap.set("n", "<C-M-n>", function() harpoon:list():next() end)
    end
}
