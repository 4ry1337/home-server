{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.dev.mobile;
in
{
  options.features.dev.mobile.adb.enable = mkEnableOption "Android Debug Bridge (adb, fastboot)";

  config = mkIf cfg.adb.enable {
    home.packages = [ pkgs.android-tools ];
  };
}
