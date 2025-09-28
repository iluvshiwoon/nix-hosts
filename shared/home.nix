{
	outputs,
  username,
  lib,
  pkgs,
  ...
}: {
  imports = [
  outputs.homeManagerModules.neovim
    ./programs
  ];

  programs.neovim.nvimdots = {
    enable = true;
    mergeLazyLock = true;
  };

  home.packages = with pkgs; [
    nix-prefetch-git
  ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  home.file = {
  };

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

    initContent = let zshInitExtra = lib.mkBefore ''
	export PATH=~/.config/emacs/bin:$PATkH
      DISABLE_MAGIC_FUNCTIONS=true
      export "MICRO_TRUECOLOR=1"
      eval "$(zoxide init --cmd cd zsh)"
    ''; zshInit = ''
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
    ''; in lib.mkMerge [ zshInitExtra zshInit ];

    shellAliases = {
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
}
