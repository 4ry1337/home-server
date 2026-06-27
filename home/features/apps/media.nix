{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.apps.media;
in {
  options.features.apps.media.enable = mkEnableOption "Enable media applications";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swayimg
      vlc
    ];

    programs.zathura.enable = true;
  };
}
