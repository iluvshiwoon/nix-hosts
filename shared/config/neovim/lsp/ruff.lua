-- neovim/lsp/ruff.lua
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", "setup.py", ".git" },
	-- Add this on_attach function
	on_attach = function(client, _)
		-- Disable hover in favor of basedpyright
		client.server_capabilities.hoverProvider = false
	end,
}
