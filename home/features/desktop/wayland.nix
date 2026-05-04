{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.desktop.wayland;

  # ---------------------------------------------------------------------------
  # Custom shell scripts
  # ---------------------------------------------------------------------------

  # Area or fullscreen screenshot → saves to ~/Pictures/Screenshots + clipboard
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    #!/usr/bin/env bash
    set -euo pipefail

    SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$SCREENSHOT_DIR"
    FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

    case "$1" in
      select)
        grim -g "$(slurp)" -t png - | tee "$FILENAME" | wl-copy
        ;;
      full)
        grim -t png - | tee "$FILENAME" | wl-copy
        ;;
      *)
        echo "Usage: $0 {select|full}"
        exit 1
        ;;
    esac

    notify-send "Screenshot Taken" "Saved as <i>$(basename "$FILENAME")</i> and copied to clipboard." -i "$FILENAME"
  '';

  # CPU + NVIDIA GPU temperature display for waybar
  waybarTempsScript = pkgs.writeShellScriptBin "waybar-temps" ''
    #!/usr/bin/env bash

    CPU_TEMP="N/A"
    for sensor in /sys/class/hwmon/hwmon*/temp*_input; do
      if [ -f "$sensor" ]; then
        name_file="$(dirname "$sensor")/name"
        if [ -f "$name_file" ]; then
          name=$(cat "$name_file" 2>/dev/null)
          if [ "$name" = "coretemp" ]; then
            temp=$(cat "$sensor" 2>/dev/null)
            if [ -n "$temp" ]; then
              CPU_TEMP=$((temp / 1000))
              break
            fi
          fi
        fi
      fi
    done

    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
    if [ -z "$GPU_TEMP" ]; then
      GPU_TEMP="N/A"
    fi

    echo "🌡️ ''${CPU_TEMP}°C | ''${GPU_TEMP}°C"
  '';

  # Debug tool — lists all detected temperature sensors
  findTempSensorsScript = pkgs.writeShellScriptBin "find-temp-sensors" ''
    #!/usr/bin/env bash
    echo "=== Finding all temperature sensors ==="

    echo "--- Hardware Monitor Sensors ---"
    for sensor in /sys/class/hwmon/hwmon*/temp*_input; do
      if [ -f "$sensor" ]; then
        name_file="$(dirname "$sensor")/name"
        name=$(cat "$name_file" 2>/dev/null || echo "unknown")
        temp=$(cat "$sensor" 2>/dev/null)
        temp_c=$((temp / 1000))
        echo "$sensor -> $name: ''${temp_c}°C"
      fi
    done

    echo
    echo "--- NVIDIA GPU via nvidia-smi ---"
    if command -v nvidia-smi >/dev/null 2>&1; then
      nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | while read temp; do
        echo "nvidia-smi -> GPU: ''${temp}°C"
      done
    else
      echo "nvidia-smi not available"
    fi
  '';

  # Systemd service status indicator for waybar
  serviceStatusScript = pkgs.writeShellScriptBin "waybar-services" ''
    #!/usr/bin/env bash

    declare -A services=(
      ["docker"]="🐳"
    )

    active_services=""
    inactive_count=0

    for service in "''${!services[@]}"; do
      if systemctl is-active --quiet "$service" 2>/dev/null; then
        active_services+="''${services[$service]}"
      else
        ((inactive_count++)) || true
      fi
    done

    if [ $inactive_count -gt 0 ]; then
      echo "$active_services ⚠️''${inactive_count}"
    else
      echo "$active_services"
    fi
  '';

  # Music visualizer bars using playerctl — shown in waybar while playing
  musicVisualizerScript = pkgs.writeShellScriptBin "waybar-music-viz" ''
    #!/usr/bin/env bash

    if ! playerctl status 2>/dev/null | grep -q "Playing"; then
      echo ""
      exit 0
    fi

    bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
    viz=""

    for i in {1..8}; do
      random_height=$((RANDOM % 8))
      viz+="''${bars[$random_height]}"
    done

    title=$(playerctl metadata title 2>/dev/null || echo "Unknown")
    echo "♪ $viz $title"
  '';

  # Weather display using wttr.in — reads WEATHER_LOCATION from ~/.env
  weatherScript = pkgs.writeShellScriptBin "waybar-weather" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -f "$HOME/.env" ]; then
      source "$HOME/.env"
    fi

    LOCATION="''${WEATHER_LOCATION:-Almaty}"
    WEATHER_URL="https://wttr.in/$LOCATION?format=%t|%C|%p"

    if ! weather_data=$(curl -s --connect-timeout 5 --max-time 10 "$WEATHER_URL" 2>/dev/null); then
      echo "🌡️ N/A"
      exit 0
    fi

    IFS='|' read -r temp condition precip <<< "$weather_data"

    case "$condition" in
      *"Clear"*|*"Sunny"*)    icon="☀️" ;;
      *"Partly cloudy"*)      icon="⛅" ;;
      *"Cloudy"*|*"Overcast"*) icon="☁️" ;;
      *"Rain"*|*"Drizzle"*)   icon="🌧️" ;;
      *"Snow"*)               icon="🌨️" ;;
      *"Thunder"*)            icon="⛈️" ;;
      *"Fog"*|*"Mist"*)       icon="🌫️" ;;
      *)                      icon="🌤️" ;;
    esac

    if [ "$precip" != "0.0mm" ] && [ -n "$precip" ]; then
      echo "$icon $temp | Rain: $precip"
    else
      echo "$icon $temp"
    fi
  '';

  # Picks a random wallpaper from the wallpapers dir and applies it via swww
  wallpaperRotateScript = pkgs.writeShellScriptBin "wallpaper-rotate" ''
    #!/usr/bin/env bash
    set -euo pipefail

    WALLPAPER_DIR="/home/rakhat/home-server/wallpapers"

    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Error: Wallpaper directory $WALLPAPER_DIR not found"
      exit 1
    fi

    WALLPAPERS=()
    while IFS= read -r -d $'\0' file; do
      WALLPAPERS+=("$file")
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0)

    if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
      echo "Error: No wallpaper files found in $WALLPAPER_DIR"
      exit 1
    fi

    RANDOM_INDEX=$((RANDOM % ''${#WALLPAPERS[@]}))
    SELECTED="''${WALLPAPERS[$RANDOM_INDEX]}"

    swww img "$SELECTED" --transition-type grow --transition-pos center --transition-duration 2
  '';

in {
  options.features.desktop.wayland.enable =
    mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {

    # ---------------------------------------------------------------------------
    # Catppuccin — places catppuccin.css in waybar config dir for @import
    # ---------------------------------------------------------------------------
    catppuccin.waybar = {
      enable = true;
      mode = "createLink";
    };

    # ---------------------------------------------------------------------------
    # Waybar
    # ---------------------------------------------------------------------------
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 36;
          spacing = 4;
          reload_style_on_change = true;

          modules-left   = [ "hyprland/workspaces" "mpris" "custom/music-viz" ];
          modules-center = [ "hyprland/window" ];
          modules-right  = [ "custom/services" "pulseaudio" "network" "cpu" "memory" "custom/temps" "clock" "tray" ];

          # -- Left modules --

          "hyprland/workspaces" = {
            format = "{id}";
            on-click = "activate";
            format-icons = {
              default = "";
              active  = "";
              urgent  = "";
            };
            sort-by-number = true;
          };

          "mpris" = {
            format         = "{player_icon}";
            format-paused  = "";
            format-stopped = "";
            player-icons = {
              default = "";
              mpv     = "🎵";
            };
            on-click       = "playerctl play-pause";
            tooltip-format = "{player}: {title} - {artist}";
          };

          "custom/music-viz" = {
            exec     = "waybar-music-viz";
            format   = "{}";
            interval = 1;
            tooltip  = false;
            on-click       = "playerctl play-pause";
            on-scroll-up   = "playerctl next";
            on-scroll-down = "playerctl previous";
          };

          # -- Center modules --

          "hyprland/window" = {
            format         = "{}";
            separate-outputs = true;
            max-length     = 50;
          };

          # -- Right modules --

          "custom/services" = {
            exec           = "waybar-services";
            format         = "{}";
            interval       = 30;
            tooltip        = true;
            tooltip-format = "Service Status (🐳=Docker)";
            on-click       = "alacritty -e bash -c 'systemctl --no-pager status docker; read'";
          };

          "pulseaudio" = {
            format       = "{icon} {volume}%";
            format-muted = " Muted";
            format-icons = {
              default = [ "" "" "" ];
            };
            on-click = "pwvucontrol";
          };

          "network" = {
            format-wifi        = " ";
            format-ethernet    = "󰈀";
            format-disconnected = "󰌙";
            tooltip-format     = "{ifname}: {essid} via {gwaddr}";
          };

          "cpu" = {
            format   = "󰻠 {usage}%";
            interval = 5;
            tooltip  = true;
            on-click = "alacritty -e btop";
          };

          "memory" = {
            format   = "󰍛 {}%";
            interval = 10;
            tooltip  = true;
            on-click = "alacritty -e bash -c 'free -h; read'";
          };

          "custom/temps" = {
            exec           = "waybar-temps";
            format         = "{}";
            interval       = 10;
            tooltip        = true;
            tooltip-format = "CPU and GPU Temperatures";
            on-click       = "alacritty -e bash -c 'sensors; read'";
          };

          "clock" = {
            format         = " {:%H:%M}";
            tooltip-format = "<big>{:%A, %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>";
            calendar = {
              mode         = "year";
              mode-mon-col = 3;
              weeks-pos    = "right";
              on-scroll    = 1;
              format = {
                months   = "<span color='#ffead3'><b>{}</b></span>";
                days     = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks    = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today    = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
          };

          "tray" = {
            icon-size = 16;
            spacing   = 10;
          };
        };
      };

      style = ''
        /* Catppuccin Mocha palette — provided by catppuccin.waybar module */
        @import "catppuccin.css";

        * {
          font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", sans-serif;
          font-size: 14px;
          font-weight: 500;
          min-height: 0;
          border: none;
        }

        window#waybar {
          background-color: @base;
          color: @text;
          padding: 4px 8px;
        }

        /* Workspace buttons */
        #workspaces button {
          padding: 4px 8px;
          margin: 4px 2px;
          background: transparent;
          color: @subtext0;
        }

        #workspaces button.active {
          background: @mauve;
          color: @base;
          border-radius: 4px;
        }

        #workspaces button:hover {
          background: @surface1;
          color: @text;
          border-radius: 4px;
        }

        /* Right-side module pill styling */
        #cpu,
        #memory,
        #custom-temps,
        #pulseaudio,
        #network,
        #clock,
        #mpris,
        #custom-services,
        #custom-music-viz {
          padding: 4px 10px;
          margin: 4px 3px;
          background: @surface0;
          color: @text;
          border-radius: 4px;
        }

        /* Temperature warning animation */
        #custom-temps.critical {
          background: @red;
          color: @base;
          animation: temp-warning 1s ease-in-out infinite alternate;
        }

        @keyframes temp-warning {
          from { opacity: 1; }
          to   { opacity: 0.7; }
        }

        /* Center window title */
        #window {
          background: transparent;
          color: @subtext1;
          font-style: italic;
        }

        #tray {
          padding: 4px 10px;
          margin: 4px 3px;
          background: @surface0;
          border-radius: 4px;
        }

        tooltip {
          background: @base;
          border-radius: 6px;
          border: 1px solid @surface1;
          color: @text;
        }
      '';
    };

    # ---------------------------------------------------------------------------
    # Packages — wayland tools + custom scripts
    # ---------------------------------------------------------------------------
    home.packages = with pkgs; [
      # Wayland utilities
      grim            # Screenshot tool
      hyprlock        # Screen locker
      qt6.qtwayland   # Qt6 Wayland backend
      slurp           # Screen area selection
      waypipe         # Wayland network proxy
      wf-recorder     # Screen recorder
      wl-mirror       # Display mirroring
      wl-clipboard    # Clipboard CLI
      wlogout         # Logout menu
      wtype           # Wayland keyboard input
      ydotool         # Input automation

      # Media / wallpaper
      playerctl       # MPRIS media controller
      swww            # Animated wallpaper daemon

      # Custom scripts
      screenshotScript
      waybarTempsScript
      findTempSensorsScript
      serviceStatusScript
      musicVisualizerScript
      weatherScript
      wallpaperRotateScript
    ];
  };
}
