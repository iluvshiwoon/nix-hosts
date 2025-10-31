-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			svelte = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			sql = { "pg_format" }, -- Note: nix package is pgformatter, but command is pg_format
			lua = { "stylua" },
			nix = { "alejandra" },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- This is the recommended setting
		},
	},
}
