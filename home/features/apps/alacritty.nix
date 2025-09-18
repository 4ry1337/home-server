{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.alacritty;
in {
  options.features.apps.alacritty.enable = mkEnableOption "Enable Alacritty";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ alacritty ];
    programs.alacritty.enable = true;
  };
}
