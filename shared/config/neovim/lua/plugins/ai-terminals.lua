return {
  "aweis89/ai-terminals.nvim",
  -- This plugin depends on snacks.nvim for some UI components
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- We explicitly choose the 'tmux' backend for performance and persistence.
    backend = "tmux",

    -- Here we define our AI terminals. We'll start with just Gemini.
    terminals = {
      -- By setting the others to nil, we override the plugin's defaults.
      aider = nil,
      claude = nil,
      goose = nil,
      codex = nil,
      cursor = nil,
      opencode = nil,
      -- This is our primary AI assistant.
      gemini = {
        -- The command to start gemini-cli. The '-p' flag is for prompt mode.
        cmd = "gemini -p",
        -- This template defines how file paths are sent to the AI.
        -- '@path/to/file.js' is a common convention.
        path_header_template = "@%s",
      },
    },

    -- This powerful feature automatically watches your project for file changes
    -- made by the AI and reloads them in Neovim.
    watch_cwd = {
      enabled = true,
      -- It's crucial to ignore directories like .git and node_modules
      -- to avoid performance issues.
      ignore = {
        "**/.git/**",
        "**/node_modules/**",
        "**/.venv/**",
        "**/*.log",
      },
      -- This will also respect the .gitignore file in your project root.
      gitignore = true,
    },
    -- Automatically format files when they are changed by the AI.
    trigger_formatting = {
      enabled = true,
    },

    -- Configuration specific to the tmux popups
    tmux = {
      -- A 90% width and 85% height popup is a good starting point.
      width = 0.9,
      height = 0.85,
      -- Don't show the tmux status bar inside the popup for a cleaner look.
      on_init = {
        "set status off",
      },
    },

    -- This section is for creating custom, reusable prompts.
    -- This is key for a powerful SaaS workflow.
    -- prompts = {
    --   generate_tests = "Write comprehensive unit tests for the selected code using the vitest framework. Include tests for edge cases.",
    --   document_api = "Generate OpenAPI (Swagger) documentation for the selected API endpoint code.",
    -- },
    --
    -- -- These keymaps will trigger your custom prompts.
    -- prompt_keymaps = {
    --   {
    --     key = "<leader>agt", -- Mnemonic: AI Gemini Test
    --     term = "gemini",
    --     prompt = "generate_tests",
    --     desc = "Gemini: Generate unit tests for selection",
    --   },
    --   {
    --     key = "<leader>agd", -- Mnemonic: AI Gemini Document
    --     term = "gemini",
    --     prompt = "document_api",
    --     desc = "Gemini: Document API endpoint",
    --   },
    -- },
    -- Auto-generate a consistent set of keymaps for all your terminals.
    auto_terminal_keymaps = {
      prefix = "<leader>a",
      terminals = {
        { name = "gemini", key = "g" },
      },
    },
  },
  -- The config function ensures that the setup function is called with our options.
  config = function(_, opts)
    require("ai-terminals").setup(opts)
  end,
}
