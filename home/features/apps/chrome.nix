{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.chrome;
in {
  options.features.apps.chrome.enable = mkEnableOption "Enable Google Chrome";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ google-chrome ];
  };
}
