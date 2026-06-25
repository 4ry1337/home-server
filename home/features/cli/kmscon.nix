{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.kmscon;
in {
  options.features.cli.kmscon.enable = mkEnableOption "Enable kmscon";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kmscon
    ];
  };
}
