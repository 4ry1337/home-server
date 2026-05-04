{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.telegram;
in {
  options.features.apps.telegram.enable = mkEnableOption "Enable Telegram";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.stable.telegram-desktop ];
  };
}
