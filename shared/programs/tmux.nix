{pkgs,inputs,...} : {
programs.tmux = {
  enable = true;
  terminal = "screen-255color";
  baseIndex = 1;
  historyLimit = 10000;
  escapeTime = 10;
  focusEvents = true;

  plugins = with pkgs.tmuxPlugins; [
  {
  	plugin = mkTmuxPlugin {
          # A name for our custom plugin package
          pluginName = "tmux-toggle-popup";
          # The version doesn't matter much, "main" is fine
          version = "main";
          # We point it to the source code we fetched in our flake.nix
          src = inputs.tmux-toggle-popup;
        };
	extraConfig = "set -g @popup-toggle-mode 'force-close'";
  }
  ];

  extraConfig = ''
    set -g renumber-windows on
    # --- Keybindings ---
    unbind C-b
    set-option -g prefix C-Space
    bind-key C-Space send-prefix

    # --- Quality of Life ---
    set -g mouse on

    # --- AI Terminals Configuration ---

    # --- Aesthetics (Optional but Recommended) ---
    set -g status-style "bg=black,fg=white"
    set -g status-left ""
    set -g status-right "#(whoami)@#h | %Y-%m-%d %H:%M"
    set -g window-status-current-style "bg=blue,fg=black"
    set -g window-status-current-format " #I:#W "
    set -g window-status-format " #I:#W "

  '';
};
}
