-- neovim/lua/plugins/conjure.lua
return {
	"Olical/conjure",
	-- Load conjure when you open a JS, TS, or Svelte file
	ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },

	-- init runs BEFORE the plugin loads, which is required
	-- for setting g:conjure global variables.
	init = function()
		local filetypes = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
		}

		-- 1. Add our JS filetypes to Conjure's list
		if not vim.g["conjure#filetypes"] then
			vim.g["conjure#filetypes"] = {}
		end
		vim.list_extend(vim.g["conjure#filetypes"], filetypes)

		-- 2. Map each filetype to the built-in JS client
		for _, ft in ipairs(filetypes) do
			vim.g["conjure#filetype#" .. ft] = "conjure.client.javascript.stdio"
		end

		-- 3. Fix the display: Disable the HUD "box" and enable inline virtual text
		vim.g["conjure#log#hud#enabled"] = false
		vim.g["conjure#eval#inline_results"] = true

		-- 4. Enable the "flash" highlight on evaluated forms
		vim.g["conjure#highlight#enabled"] = true

		-- 5. Prevent auto-connecting on load
		vim.g["conjure#client_on_load"] = false
	end,

	-- These keys will be set up for the filetypes above
	-- and will appear in which-key
	keys = {
		-- Log commands
		{ "<leader>cl", "<cmd>ConjureLogToggle<cr>", desc = "Conjure Log Toggle" },

		-- Eval commands
		{ "<leader>ee", "<cmd>ConjureEvalCurrentForm<cr>", desc = "Conjure Eval Form" },
		{ "<leader>er", "<cmd>ConjureEvalRootForm<cr>", desc = "Conjure Eval Root Block" },
		{ "<leader>eb", "<cmd>ConjureEvalBuffer<cr>", desc = "Conjure Eval Buffer" },
		{ "<leader>ef", "<cmd>ConjureEvalFile<cr>", desc = "Conjure Eval File (Disk)" },
	},

	config = false,
}
