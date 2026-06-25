{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.ai;
in
{
  options.features.cli.ai.enable = mkEnableOption "Enable AI capabilities";

  config = mkIf cfg.enable {
    programs.claude-code.enable = true;
  };
}
