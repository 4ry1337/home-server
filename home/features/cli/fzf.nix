{ config, lib, ... }:
with lib;
let cfg = config.features.cli.fzf;
in {
  options.features.cli.fzf.enable =
    mkEnableOption "enable extended tmux configuration";

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
