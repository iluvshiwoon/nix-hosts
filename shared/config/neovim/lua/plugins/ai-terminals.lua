return {
	"aweis89/ai-terminals.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		backend = "tmux",
		trigger_formatting = {
			enabled = true,
			timeout_ms = 5000, -- Optional: Adjust timeout
		},
		-- Add this 'watch_cwd' table inside the 'opts' table of ai-terminals.lua
		watch_cwd = {
			enabled = true,
			-- When true, it will automatically use the rules from your .gitignore file.
			gitignore = true,
			-- Add any extra patterns here. These are globs, not simple strings.
			ignore = {
				"**/node_modules/**",
				"**/.svelte-kit/**",
				"**/supabase/functions/**", -- Often good to ignore generated or bundled functions
				"**/*.log",
			},
		},
		terminals = {
			gemini = {
				cmd = "gemini",
				path_header_template = "@%s",
			},
		},
		auto_terminal_keymaps = {
			prefix = "<leader>a",
			terminals = {
				{ name = "gemini", key = "g" },
			},
		},
		tmux = {
			width = 0.9, -- 90% of terminal width
			height = 0.85, -- 85% of terminal height
			log_level = vim.log.levels.WARN,
		},
	},
	config = function(_, opts)
		require("ai-terminals").setup(opts)
	end,
}
