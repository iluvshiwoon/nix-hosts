vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<space>en", function()
	require("telescope.builtin").find_files({
		cwd = "~/nix-hosts/shared/config/neovim/",
	})
end)
-- Add these to your lua/config/maps.lua
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- vim.cmd("colorscheme kanso-pearl")
