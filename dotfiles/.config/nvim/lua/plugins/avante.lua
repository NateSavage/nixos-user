return {
    "yetone/avante.nvim",
    enabled = true,
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        instructions_file = "avante.md",
        provider = "claude",
        providers = {
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-sonnet-4-5",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 8192,
                }
            },
        },
        windows = {
            position = "right",
            wrap = true,
            width = 30,
            sidebar_header = {
                enabled = true,
                align = "center",
                rounded = true,
            },
        },
        highlights = {
            diff = {
                current = "AvanteConflictCurrent",
                incoming = "AvanteConflictIncoming",
            },
        },
        hints = {
            enabled = false,
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-tree/nvim-web-devicons",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
