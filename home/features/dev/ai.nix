{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.dev.ai;
in
{
  options.features.dev.ai = {
    claude-code.enable = mkEnableOption "Claude Code CLI";
    codex.enable = mkEnableOption "Codex CLI";
    markitdown.enable = mkEnableOption "markitdown CLI (+ MCP server for Claude Code)";
  };

  config = mkMerge [
    (mkIf cfg.claude-code.enable {
      programs.claude-code.enable = true;
    })
    (mkIf cfg.codex.enable {
      programs.codex.enable = true;
    })
    (mkIf cfg.markitdown.enable {
      home.packages = [ pkgs.markitdown ];
      # MCP only registered when Claude Code is enabled
      programs.claude-code.mcpServers = mkIf cfg.claude-code.enable {
        markitdown = {
          type = "stdio";
          command = getExe pkgs.markitdown-mcp;
        };
      };
    })
  ];
}
