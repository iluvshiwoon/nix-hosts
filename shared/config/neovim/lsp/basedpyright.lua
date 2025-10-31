return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	settings = {
		python = {
			analysis = {
				-- These help find your venv and libraries
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				-- This tells it to analyze the whole project, not just open files
				diagnosticMode = "workspace",
			},
		},
	},
}
