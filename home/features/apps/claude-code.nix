{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.claude-code;
in {
  options.features.apps.claude-code.enable = mkEnableOption "Enable Claude Code";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ claude-code ];
  };
}
