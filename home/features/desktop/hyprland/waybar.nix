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
    programs.waybar = {
      enable = true;
      # start as a systemd user service alongside the desktop session
      systemd.enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 30;

          # Left: workspace indicators
          modules-left = [ "hyprland/workspaces" ];
          # Center: clock
          modules-center = [ "clock" ];
          # Right: system tray
          modules-right = [ "tray" ];

          "hyprland/workspaces" = {
            format = "{id}";
            on-click = "activate";
          };

          "clock" = {
            format = "{:%H:%M}";
            tooltip-format = "{:%A, %B %d %Y}";
          };

          "tray" = {
            spacing = 8;
          };
        }
      ];

      style = ''
        * {
          font-family: monospace;
          font-size: 13px;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background: rgba(0, 0, 0, 0.85);
          color: #cdd6f4;
        }

        #workspaces button {
          padding: 0 8px;
          color: #6c7086;
        }

        #workspaces button.active {
          color: #cdd6f4;
        }

        #clock {
          padding: 0 12px;
        }

        #tray {
          padding: 0 8px;
        }
      '';
    };
  };
}
