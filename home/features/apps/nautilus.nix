{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.nautilus;
in {
  options.features.apps.nautilus.enable = mkEnableOption "Enable Nautilus File
  Manager";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.nautilus ];
  };
}
