{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.blender;
in
{
  options.features.apps.blender.enable = mkEnableOption "Enable blender application";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
    ];
  };
}
