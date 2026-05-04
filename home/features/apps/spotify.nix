{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.spotify;
in {
  options.features.apps.spotify.enable = mkEnableOption "Enable Spotify";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.stable.spotify ];
  };
}
