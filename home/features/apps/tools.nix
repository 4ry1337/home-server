{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.tools;
in
{
  options.features.apps.tools = {
    dua.enable = mkEnableOption "Enable baobab DUA";
  };

  config = mkMerge [
    (mkIf cfg.dua.enable {
      home.packages = with pkgs; [
        baobab
      ];
    })
  ];
}
