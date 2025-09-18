{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.tmux;
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "master";
      sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
  };
in {
  options.features.cli.tmux.enable =
    mkEnableOption "enable extended tmux configuration";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      aggressiveResize = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      keyMode = "vi";
      newSession = true;
      secureSocket = true;
      shell = "${pkgs.zsh}/bin/zsh";
      shortcut = "a";
      terminal = "screen-256color";

      plugins = with pkgs.tmuxPlugins; [
        tokyo-night
        yank
        sensible
        vim-tmux-navigator
      ];

      extraConfig = ''
        # set-default colorset-option -ga terminal-overrides ",xterm-256color:Tc"
        set -as terminal-features ",xterm-256color:RGB"
        # set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on

        unbind C-b

        unbind %
        unbind c
        unbind '"'

        bind n split-window -v -c "#{pane_current_path}"
        bind s split-window -h -c "#{pane_current_path}"
        bind a new-window -c "#{pane_current_path}"

        set -g prefix C-Space
        bind C-Space send-prefix

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # set vi-mode
        set-window-option -g mode-keys vi

        # Alt vim keys to switch windows
        bind -n M-h previous-window
        bind -n M-l next-window

        # set -g @tokyo-night-tmux_window_id_style none
        set -g @tokyo-night-tmux_window_id_style hsquare
        set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
        set -g @tokyo-night-tmux_transparent 1  # 1 or 0
        set -g @tokyo-night-tmux_window_tidy_icons 1
        set -g @tokyo-night-tmux_show_datetime 0
        set -g @tokyo-night-tmux_show_git 0
        set -g @tokyo-night-tmux_show_music 0

        run-shell ${tokyo-night}/share/tmux-plugins/tokyo-night/tokyo-night.tmux
      '';
    };
  };
}
