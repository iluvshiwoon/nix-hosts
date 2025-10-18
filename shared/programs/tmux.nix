{
  pkgs,
  inputs,
  ...
}: let
  tmux-toggle-popup-plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-toggle-popup";
    version = "0.4.4";
    rtpFilePath = "toggle-popup.tmux";
    src = inputs.tmux-toggle-popup;
  };
in {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 10;
    focusEvents = true;

    plugins = with pkgs; [
      tmux-toggle-popup-plugin
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    extraConfig = ''
      # --- Core Settings ---
      # Set the prefix to C-a for easier access
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Enable mouse mode
      set -g mouse on

      # Improve usability
      set -g renumber-windows on
      set -g set-clipboard on

      # --- Vi Mode Configuration ---
      # Set vi-keys for copy mode
      set-window-option -g mode-keys vi

      # Bind keys for vi-mode selection and copying
      # 'v' begins selection, 'y' copies to system clipboard
      # NOTE: Use "xclip -i -sel c" on Linux/X11 or "wl-copy" on Linux/Wayland
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # --- Custom Keybindings ---
      # Split panes and open in the current directory
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Generic popup binding (for non-AI terminal use)
      bind C-t run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75%"

      # Reload config (Note: `home-manager switch` is the canonical way to apply changes)
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Plugin Settings ---
      # Configure the popup plugin mode
      set -g @popup-toggle-mode 'force-close'

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
