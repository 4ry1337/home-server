{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.apps.calendar;
in {
  options.features.apps.calendar.enable = mkEnableOption "Enable calendar application";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.thunderbird ];
  };
}
