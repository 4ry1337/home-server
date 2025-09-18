{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.fastfetch;
in {
  options.features.cli.fastfetch.enable =
    mkEnableOption "enable extended fastfetch configuration";

  config = mkIf cfg.enable { home.manager = with pkgs; [ fastfetch ]; };
}
