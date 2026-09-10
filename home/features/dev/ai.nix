{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.dev.ai;
in
{
  options.features.dev.ai.claude-code.enable = mkEnableOption "Claude Code CLI";

  config = mkIf cfg.claude-code.enable {
    programs.claude-code.enable = true;
  };
}
