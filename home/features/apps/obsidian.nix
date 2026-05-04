{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.obsidian;
in {
  options.features.apps.obsidian.enable = mkEnableOption "Enable Obsidian";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
