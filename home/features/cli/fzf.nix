{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.fzf;
in
{
  options.features.cli.fzf.enable = mkEnableOption "Enable extended fzf configuration";

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidget.command = "fd --type d --exclude .git --follow --hidden";
    };

    # fzf-tab is zsh-only and needs the fzf binary — lives and dies with this module.
    # mkBefore: must be sourced after compinit but before autosuggestions/syntax-highlighting.
    programs.zsh.plugins = mkIf config.features.cli.zsh.enable (mkBefore [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ]);
  };
}
