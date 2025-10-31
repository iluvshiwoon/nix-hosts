-- neovim/lsp/ruff.lua
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", "setup.py", ".git" },
	on_attach = function(client, _)
		-- Disable hover in favor of basedpyright
		client.server_capabilities.hoverProvider = false
	end,
	capabilities = {
		general = {
			-- positionEncodings = { "utf-8", "utf-16", "utf-32" }  <--- this is the default
			positionEncodings = { "utf-16" },
		},
	},
}
