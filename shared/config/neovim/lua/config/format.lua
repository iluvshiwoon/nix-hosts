local M = {}

M.setup = function()
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.nix",
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.fn.system("nix fmt " .. vim.fn.shellescape(file))
  end,
  desc = "Format Nix file with nix fmt on save"
})
end

return M
