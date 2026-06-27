{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.cli.disk;
in
{
  options.features.cli.disk.enable = mkEnableOption "disk management tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # space analysis
      gdu
      duf
      dust

      # archives
      ouch
      unzip

      # disk health
      smartmontools
      nvme-cli

      # sync
      rsync
    ];
  };
}
