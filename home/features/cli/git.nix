{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.git;
in
{
  options.features.cli.git.enable = mkEnableOption "Enable git";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        ghq.root = "~/Projects";
      };
    };
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        aliases = {
          co = "pr checkout";
        };
      };
    };
    programs.lazygit.enable = true;
    home.packages = [ pkgs.ghq ];
  };
}
