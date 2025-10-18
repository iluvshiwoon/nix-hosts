{ pkgs, inputs, ... }:

let
  # Define the custom tmux plugin package using the expression you provided.
  # This builds the plugin from the source specified in your flake inputs.
  tmux-toggle-popup-plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-toggle-popup";
    version = "0.4.4";
    rtpFilePath = "toggle-popup.tmux";
    # This correctly points to the source from your flake.nix inputs
    src = inputs.tmux-toggle-popup;
  };
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 10;
    focusEvents = true;

    plugins = with pkgs; [
      # Add our custom-built plugin to the list of plugins
      tmux-toggle-popup-plugin

      # Other plugins
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    # A single, consolidated extraConfig block
    extraConfig = ''
      # --- Keybindings ---
      # Set the prefix to C-a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Popup binding
      bind C-t run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75%"

      # Split panes using | and - (and open in the current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
bind-key -T copy-mode-vi v send-keys -X begin-selection
  bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
  bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      # Reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Quality of Life ---
      set -g mouse on
      setw -g mode-keys vi
      set -g renumber-windows on
      set -g set-clipboard on

      # --- Kanso Theme ---
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

