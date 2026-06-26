{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    services.wayle = {
      enable = true;
      settings = {
        bar = {
          bg = "bg-base";
          button-group-padding = 0.25;
          button-icon-size = 0.8;
          button-rounding = "md";
          layout = [
            {
              center = [
                "notifications"
                "clock"
                "media"
                "hyprsunset"
              ];
              left = [
                "dashboard"
                "hyprland-workspaces"
              ];
              monitor = "*";
              right = [
                "keyboard-input"
                "systray"
                {
                  name = "right-controls";
                  modules = [
                    "bluetooth"
                    "network"
                    "brightness"
                    "volume"
                  ];
                }
              ];
              show = true;
            }
          ];
        };
        general = {
          font-mono = "Iosevka Nerd Font Mono";
          tearing-mode = true;
        };
        wallpaper = {
          cycling-enabled = true;
          cycling-directory = "/home/rakhat/Pictures/wallpapers/wallpapers/Dynamic-Wallpapers/Dark/";
          cycling-mode = "shuffle";
          cycling-interval-mins = 15;
          cycling-same-image = true;
        };
        modules = {
          bluetooth = {
            label-show = false;
          };
          brightness = {
            label-show = false;
          };
          media = {
            label-max-length = 20;
            label-show = false;
          };
          microphone = {
            label-show = false;
          };
          dashboard = {
            dropdown-lock-command = "hyprlock";
          };
          keyboard-input = {
            icon-show = false;
            layout-alias-map = {
              "English (US)" = "en";
              "Russian" = "ru";
            };
          };
          notifications = {
            blocklist = [ "Spotify" ];
          };
          network = {
            label-show = false;
          };
          volume = {
            label-show = false;
          };
          hyprsunset = {
            label-show = false;
          };
          weather = {
            location = "Astana";
          };
        };
        osd = {
          duration = 1500;
          margin = 20;
          position = "top";
        };
        styling = {
          palette = {
            bg = "#11111b";
            blue = "#74c7ec";
            elevated = "#1e1e2e";
            fg = "#cdd6f4";
            fg-muted = "#bac2de";
            green = "#a6e3a1";
            primary = "#b4befe";
            red = "#f38ba8";
            surface = "#181825";
            yellow = "#f9e2af";
          };
        };
      };
    };
  };
}
