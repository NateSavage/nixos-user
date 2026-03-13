return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require("fff.download").download_or_build_binary()
  end,
  -- if you are using nixos
  -- build = "nix run .#release",
  opts = {
    prompt = '🕯 ',
    layout = {
      height = 0.85,
      width = 0.85,
      prompt_position = 'bottom', -- or 'top'
      preview_position = 'right', -- or 'left', 'right', 'top', 'bottom'
      preview_size = 0.5,
    },
    debug = {
      enabled = true,     -- we expect your collaboration at least during the beta
      show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    },
    keymaps = {
      move_up = { '<Up>', '<A-k>' },
      move_down = { '<Down>', '<A-j>' },
      preview_scroll_up = { '<C-u>', '<C-k>' },
      preview_scroll_down = {'<C-d>', '<C-j>'  },
      close = { '<Esc>', '<C-c>' },
      select = '<CR>',
    },
  },
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  keys = {
    {
      "ff",
      function() require('fff').find_files() end,
      desc = 'FFFind files',
    },
    {
      "fg",
      function() require('fff').find_in_git_root() end,
      desc = 'FFFind files in git',
    },
  }
}
