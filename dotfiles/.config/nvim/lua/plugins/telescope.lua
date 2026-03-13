return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                -- displaying file name before directory is currently broken on windows
                path_display = { filename_first = { reverse_directories = false } },
                mappings = {
                    i = {
                        -- alt+j select next
                        ["<A-j>"] = {
                            actions.move_selection_next,
                            type = "action",
                            opts = { nowait = true, silent = true }
                        },
                        -- alt+k select previous
                        ["<A-k>"] = {
                            actions.move_selection_previous,
                            type = "action",
                            opts = { nowait = true, silent = true }
                        },
                    }
                },
                file_ignore_patterns = {
                    "build/*", -- Exclude build folder
                    "%.dll",  -- binary
                    -- unity game engine
                    "%.meta",
                    "%.anim",
                    "%.asset",
                    "%.mat",
                    "%.terrainlayer",
                    "%.unity",
                    "%.prefab", -- readable text, but we don't normally want to edit these files in neovim
                    "%.preset",
                    "%.lighting",
                    "%.ogg",
                    -- pure onyx
                    "GameDB\\Container\\*",
                    -- godot game engine
                    "%.uid",
                    "%.res",    -- binary scene format
                    -- images
                    "%.afphoto", -- binary
                    "%.psd",    -- sometimes binary? x_x
                    "%.jpg",
                    "%.png",
                    "%.tga",
                    "%.exr",
                    -- audio
                    "%.wav",
                    -- 3d files
                    "%.obj",  --
                    "%.fbx",  -- autodesk proprietary 3d interchange format
                    "%.FBX",  -- autodesk proprietary 3d interchange format
                    "%.glb",  -- OpenGL binary transmission format
                    "%.gltf", -- OpenGL text format
                    "%.blend", -- are blend files binary?
                    "%.mb",   -- maya binary
                    "%.ma",   -- maya ascii
                    -- fonts
                    "%.ttf",
                    "%.TTF",
                },
            },
        })

        local builtin = require('telescope.builtin')
        -- vim.keymap.set("n", "<leader>ff", builtin.find_files, {}) -- replaced while testing fff for faster search
        vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
        vim.keymap.set("n", "<leader>fw", builtin.live_grep, {}) -- requires ripgrep in path as rg
        vim.keymap.set("n", "gm", builtin.git_status, {})     -- browse modified git files
    end
}
