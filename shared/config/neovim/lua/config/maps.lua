vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n","<space>fh", require('telescope.builtin').help_tags)
    vim.keymap.set("n","<space>fd", require('telescope.builtin').find_files)
    vim.keymap.set("n","<space>en", function ()
      require('telescope.builtin').find_files {
	cwd = "~/home-manager/config/nvim/"
      }
    end)

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- vim.cmd("colorscheme kanso-pearl")
