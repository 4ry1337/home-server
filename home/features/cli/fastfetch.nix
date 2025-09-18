{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.fastfetch;
in {
  options.features.cli.fastfetch.enable = mkEnableOption "Enable Fastfetch";

  config = mkIf cfg.enable { home.packages = with pkgs; [ fastfetch ]; };
}
