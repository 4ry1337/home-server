{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.apps.obs;
in {
  options.features.apps.obs.enable = mkEnableOption "Enable OBS Studio";

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-backgroundremoval
        # distroav -- NDI protocol: send/receive video over LAN between machines, no capture card needed
      ];
    };

    systemd.user.services.obs-spotify-widget = {
      Unit = {
        Description = "OBS Spotify widget (MPRIS D-Bus → HTTP)";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.obs-spotify-widget}/bin/obs_spotify_widget";
        Restart = "on-failure";
      };
    };
  };
}
