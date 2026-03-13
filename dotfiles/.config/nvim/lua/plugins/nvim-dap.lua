return {
    'mfussenegger/nvim-dap',
    enabled = true,
    --event = "VeryLazy",
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>dl", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dh", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dg", function() vim.cmd(":DapNew") end, desc = "Start New Session" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Quit Debugging" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local dap = require('dap')
      dap.adapters.godot = {
        type = "server",
        host = '127.0.0.1',
        port = 6006,
        options = {
          initialize_timeout_sec = 10
        }
      }
      dap.configurations.gdscript = {{
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        --[[
	    "address": "127.0.0.1",
	    "port": 6007,
	    "scene": "main|current|pinned|<path>",
	    "editor_path": "<path>",
	    
        // engine command line flags
	    "profiling": false,
	    "single_threaded_scene": false,
	    "debug_collisions": false,
	    "debug_paths": false,
	    "debug_navigation": false,
	    "debug_avoidance": false,
	    "debug_stringnames": false,
	    "frame_delay": 0,
	    "time_scale": 1.0,
	    "disable_vsync": false,
	    "fixed_fps": 60,
	    
        // anything else
	    "additional_options": ""
        ]]--


      }}

    end
}
