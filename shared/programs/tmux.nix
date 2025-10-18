{ pkgs, inputs, ... }: {
  programs.tmux = {
    enable = true;
    # Set zsh as the default shell for tmux
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 10;
    focusEvents = true;

    plugins = with pkgs.tmuxPlugins; [
      # Persists tmux environment across system restarts
      resurrect
      # Continuous saving of tmux environment
      continuum
      # A popup window for tmux
      {
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-toggle-popup";
          version = "main";
          src = inputs.tmux-toggle-popup;
        };
        extraConfig = ''
          set -g @popup-toggle '${inputs.tmux-toggle-popup}/bin/tmux-toggle-popup'
          set -g @popup-toggle-mode 'force-close'
        '';
      }
    ];

    extraConfig = ''
      # --- Keybindings ---
      # Set the prefix to C-Space
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Quality of Life ---
      set -g mouse on
      setw -g mode-keys vi
      set -g renumber-windows on
      set -g set-clipboard on

      # --- Kanso Theme ---
      # Transparent status bar with black text to match your ghostty theme
      set -g status-style "bg=default,fg=#22262D"
      set -g status-left ""
      set -g status-right "#(whoami)@#h | %Y-%m-%d %H:%M"
      set -g window-status-current-style "bg=default,fg=#4d699b"
      set -g window-status-current-format " #I:#W "
      set -g window-status-format " #I:#W "
      set -g pane-border-style "fg=#393B44"
      set -g pane-active-border-style "fg=#8ba4b0"
    '';
  };
}
