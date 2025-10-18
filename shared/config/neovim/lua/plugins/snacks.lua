-- lua/plugins/snacks.lua
return {
	"folke/snacks.nvim",
	opts = function(_, opts)
		-- This line is the bridge that connects snacks to ai-terminals
		local snacks_actions = require("ai-terminals.snacks_actions")
		return snacks_actions.apply(opts)
	end,
}
