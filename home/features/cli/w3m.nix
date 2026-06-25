{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.w3m;
in
{
  options.features.cli.w3m.enable = mkEnableOption "Enable w3m";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ddgr
      w3m
    ];
  };
}
