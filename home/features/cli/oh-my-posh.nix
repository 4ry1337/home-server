{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.oh-my-posh;
in {
  options.features.cli.oh-my-posh.enable = mkEnableOption "Enable Oh-My-Posh";

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

