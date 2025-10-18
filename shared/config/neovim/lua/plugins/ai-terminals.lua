return {
  "aweis89/ai-terminals.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    backend = "tmux",
    terminals = {
      gemini = {
        cmd = "gemini",
        path_header_template = "@%s",
      },
    },
    auto_terminal_keymaps = {
      prefix = "<leader>a",
      terminals = {
        {name = "gemini", key = "g"},
      }
    },
    tmux = {
      width = 0.9, -- 90% of terminal width
      height = 0.85, -- 85% of terminal height
   log_level = vim.log.levels.WARN,
    },
  },
  config = function(_, opts)
    require("ai-terminals").setup(opts)
  end,
}
