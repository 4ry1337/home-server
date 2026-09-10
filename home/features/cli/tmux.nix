{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.tmux;
in
{
  options.features.cli.tmux.enable = mkEnableOption "Enable tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        resurrect
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-tmux_theme storm
            set -g @tokyo-night-tmux_transparent 1
            set -g @tokyo-night-tmux_window_id_style none
            set -g @tokyo-night-tmux_window_tidy_icons 1
            set -g @tokyo-night-tmux_show_datetime 0
            set -g @tokyo-night-tmux_show_git 0
            set -g @tokyo-night-tmux_show_music 0
          '';
        }
      ];

      extraConfig = ''
        unbind %
        unbind c
        unbind '"'

        bind v split-window -v -c "#{pane_current_path}"
        bind b split-window -h -c "#{pane_current_path}"
        bind a new-window -c "#{pane_current_path}"

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        set-option -g renumber-windows on

        bind -n M-h previous-window
        bind -n M-l next-window
      '';
    };
  };
}
