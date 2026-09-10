{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.eza;
in
{
  options.features.cli.eza.enable = mkEnableOption "Enable eza";

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };

    # only defined while eza is enabled — no dangling alias if it is turned off
    programs.zsh.shellAliases.tree = "eza --tree";
  };
}
