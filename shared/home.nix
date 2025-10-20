{
inputs,
  outputs,
  username,
  lib,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.gemini
    ./programs
  ];

  programs.neovim.nvimdots = {
    enable = true;
    mergeLazyLock = true;
  };

  home.packages = with pkgs;
    [
      nix-prefetch-git
      fzf
      cmake
      gnumake
      clang

      nodejs_latest
      bun
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  programs.gemini.settingsJson = builtins.readFile ./config/gemini/settings.json;

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "fzf"];
    };

    initContent = let
      zshInitExtra = lib.mkBefore ''
        export PATH=~/.config/emacs/bin:$PATH
             DISABLE_MAGIC_FUNCTIONS=true
             export "MICRO_TRUECOLOR=1"
             eval "$(zoxide init --cmd cd zsh)"
      '';
      zshInit = ''
        flakify () {
        	if [ -z "$1" ]; then
        		echo "Error: Template name required"
        			echo "Usage: nix-init-template <template-name>"
        			return 1
        			fi

        			nix flake init --refresh -t "github:iluvshiwoon/dev-env#$1"
        			direnv allow
        			echo -e ".direnv\n.envrc" >> ./.gitignore
        }
                source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    in
      lib.mkMerge [zshInitExtra zshInit];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.git = {
    enable = true;
    userName = "iluvshiwoon";
    userEmail = "sntcillian@gmail.com";
  };
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };
  };

programs.gemini = {
    enable = true;
    # We reference the extensions passed via specialArgs.
    extensions = [
      {
        name = "context7";
        src = inputs.upstash-context7;
        # customCommands = {
        #   "gcp/deploy.toml" = ''
        #     # Deploys the current project
        #     prompt = "Using gcloud, create a script to deploy the project in the current directory. Follow all best practices."
        #     model = "gemini-1.5-pro-latest"
        #     response.format = "json"
        #   '';
        #
        #   "show-api-key.toml" = ''
        #     prompt = "Show me the Upstash API key from the environment."
        #     # This is a shell command; it doesn't need a model.
        #     execute.command = "echo $UPSTASH_API_KEY"
        #   '';
        # };
        # Example of overriding the extension manifest
        geminiExtensionJson = ''
          {
    "name": "context7",
    "description": "Up-to-date code docs for any prompt",
    "version": "1.0.0",
    "mcpServers": {
      "context7": {
        "command": "npx",
        "args": [
          "-y",
          "@upstash/context7-mcp",
          "--api-key",
          "ctx7sk-85d79060-9a17-44dd-835f-89d05d448156"
        ]
      }
    },
    "contextFileName": "GEMINI.md"
          }
        '';
	geminiMd = ''
		always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.
	'';
	
      }
    ];
    globalCustomCommands = {
"git/commit.toml" = ''	
description = "Analyzes staged changes and user input to generate a clean, conventional commit command."

prompt = """
You are an expert Git user who writes excellent commit messages. Your task is to generate a complete `git commit` command based on the user's summary and the staged code changes.

**1. User's Intent:**
The user provided the following summary:
"{{args}}"

**2. Staged Code Changes (`git diff --cached`):**
!{git diff --cached}

**3. Your Instructions:**
- Analyze the staged changes to understand the full context of the commit.
- Use the user's intent to draft a commit message that follows the **Conventional Commits specification**.
- The format must be: `<type>: <subject>`. 
    - **`feat`**: A new feature (e.g., adding the session button).
    - **`fix`**: A bug fix.
    - **`chore`**: Changes to build process or auxiliary tools (e.g., configuring this command).
    - **`docs`**: Documentation only changes.
    - **`style`**: Code style changes (formatting, white-space).
    - **`refactor`**: A code change that neither fixes a bug nor adds a feature.
    - **`test`**: Adding or correcting tests.
- The final output must be a single, executable shell command: `git commit -m "<your generated message>"`
- **Example:** If the user types `/git:commit implemented the new button` and the diff shows a new Svelte component, your output should be: `git commit -m "feat: implement start session button"`
- **If the user's input is already well-formatted, simply use it.**

Generate the `git commit` command now.
"""
'';
    };
  };
}
