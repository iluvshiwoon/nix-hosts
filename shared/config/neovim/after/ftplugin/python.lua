-- neovim/after/ftplugin/python.lua
local set = vim.opt_local

-- PEP 8 standard: 4 spaces for indentation
set.shiftwidth = 4
set.tabstop = 4
set.expandtab = true
set.smartindent = true

-- Optional: line numbers
set.number = true
set.relativenumber = true
