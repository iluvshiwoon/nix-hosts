-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			svelte = { "prettierd" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			sql = { "pg_format" }, -- Note: nix package is pgformatter, but command is pg_format
			lua = { "stylua" },
			nix = { "alejandra" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- This is the recommended setting
		},
	},
}
