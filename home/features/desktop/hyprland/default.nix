{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.hyprland;
  mkLua = lib.generators.mkLuaInline;
in
{
  imports = [
    ./waybar.nix
    ./swaync.nix
    ./hyprpaper.nix
  ];

  options.features.desktop.hyprland.enable = mkEnableOption "hyprland wayland compositor";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        mainMod = {
          _var = "SUPER";
        };

        monitor = {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        };

        env = [
          {
            _args = [
              "XCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "HYPRCURSOR_SIZE"
              "24"
            ];
          }
        ];

        config = {
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            layout = "dwindle";
          };
          decoration.rounding = 8;
          input = {
            kb_layout = "us";
            follow_mouse = 1;
            sensitivity = 0;
          };
          dwindle.preserve_split = true;
        };

        window_rule = [
          {
            name = "suppress-maximize-events";
            match.class = ".*";
            suppress_event = "maximize";
          }
          # Float utility windows
          {
            name = "float-pavucontrol";
            match.class = "pavucontrol";
            floating = true;
          }
          {
            name = "float-nm-connection-editor";
            match.class = "nm-connection-editor";
            floating = true;
          }
          {
            name = "float-blueman";
            match.class = "blueman-manager";
            floating = true;
          }
          # Float file picker dialogs
          {
            name = "float-file-picker";
            match.title = "^(Open|Save|Save As).*";
            floating = true;
          }
          # Float + pin picture-in-picture
          {
            name = "float-pip";
            match.title = "^Picture-in-Picture$";
            floating = true;
            pin = true;
          }
        ];

        bind = [
          # Apps
          {
            _args = [
              "SUPER + T"
              (mkLua "hl.dsp.exec_cmd(\"alacritty\")")
            ];
          }
          {
            _args = [
              "SUPER + E"
              (mkLua "hl.dsp.exec_cmd(\"nautilus\")")
            ];
          }
          {
            _args = [
              "SUPER + S"
              (mkLua "hl.dsp.exec_cmd(\"hyprlauncher\")")
            ];
          }
          {
            _args = [
              "SUPER + ESCAPE"
              (mkLua "hl.dsp.exec_cmd(\"hyprlock\")")
            ];
          }
          {
            _args = [
              "SUPER + M"
              (mkLua "hl.dsp.exit()")
            ];
          }

          # Notifications panel
          {
            _args = [
              "SUPER + N"
              (mkLua "hl.dsp.exec_cmd(\"swaync-client -t\")")
            ];
          }

          # Window switcher (all windows, every instance)
          {
            _args = [
              "ALT + Tab"
              (mkLua "hl.dsp.exec_cmd(\"hyprshell gui --mod-key alt --key tab --close mod-key-release\")")
            ];
          }

          # Workspace: scroll with SUPER+wheel
          {
            _args = [
              "SUPER + mouse_down"
              (mkLua "hl.dsp.focus({ workspace = \"r+1\" })")
            ];
          }
          {
            _args = [
              "SUPER + mouse_up"
              (mkLua "hl.dsp.focus({ workspace = \"r-1\" })")
            ];
          }

          # Window: close
          {
            _args = [
              "SUPER + Q"
              (mkLua "hl.dsp.window.close()")
            ];
          }
          # Window: fullscreen / maximize
          {
            _args = [
              "SUPER + F"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"fullscreen\", action = \"toggle\" })")
            ];
          }
          {
            _args = [
              "SUPER + Up"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })")
            ];
          }

          # Window: focus (vim-style)
          {
            _args = [
              "SUPER + H"
              (mkLua "hl.dsp.window.focus({ direction = \"l\" })")
            ];
          }
          {
            _args = [
              "SUPER + J"
              (mkLua "hl.dsp.window.focus({ direction = \"d\" })")
            ];
          }
          {
            _args = [
              "SUPER + K"
              (mkLua "hl.dsp.window.focus({ direction = \"u\" })")
            ];
          }
          {
            _args = [
              "SUPER + L"
              (mkLua "hl.dsp.window.focus({ direction = \"r\" })")
            ];
          }

          # Window: move (vim-style + arrow keys)
          {
            _args = [
              "SUPER + SHIFT + H"
              (mkLua "hl.dsp.window.move({ direction = \"l\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + J"
              (mkLua "hl.dsp.window.move({ direction = \"d\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + K"
              (mkLua "hl.dsp.window.move({ direction = \"u\" })")
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + L"
              (mkLua "hl.dsp.window.move({ direction = \"r\" })")
            ];
          }
          {
            _args = [
              "SUPER + left"
              (mkLua "hl.dsp.window.move({ direction = \"l\" })")
            ];
          }
          {
            _args = [
              "SUPER + right"
              (mkLua "hl.dsp.window.move({ direction = \"r\" })")
            ];
          }

          # Mouse: drag / resize
          {
            _args = [
              "SUPER + mouse:272"
              (mkLua "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              "SUPER + mouse:273"
              (mkLua "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }

          # Media keys
          {
            _args = [
              "XF86AudioRaiseVolume"
              (mkLua "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (mkLua "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (mkLua "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              "XF86AudioMicMute"
              (mkLua "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessUp"
              (mkLua "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%+\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (mkLua "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%-\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
        ];
      };

      extraConfig = ''
        -- Workspace switching 1-10
        for i = 1, 10 do
          local key = i % 10
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Screenshot region to clipboard
        hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bash -c 'grim -g \"$(slurp)\" - | wl-copy'"))

        -- Clipboard history
        hl.bind("SUPER + V", hl.dsp.exec_cmd("bash -c 'cliphist list | hyprlauncher -m | cliphist decode | wl-copy'"))

        -- Resize submap: SUPER+R to enter, H/J/K/L to resize, ESC to exit
        hl.bind("SUPER + R", hl.dsp.submap("resize"))
        hl.submap("resize", function()
          hl.bind("H", hl.dsp.window.resize_active({ x = -20, y = 0 }), { repeating = true })
          hl.bind("L", hl.dsp.window.resize_active({ x = 20, y = 0 }), { repeating = true })
          hl.bind("K", hl.dsp.window.resize_active({ x = 0, y = -20 }), { repeating = true })
          hl.bind("J", hl.dsp.window.resize_active({ x = 0, y = 20 }), { repeating = true })
          hl.bind("escape", hl.dsp.submap("reset"))
        end)

        hl.on("hyprland.start", function()
          -- Polkit authentication agent
          hl.exec_cmd("hyprpolkitagent")
          -- Window switcher daemon (enables Alt+Tab overlay)
          hl.exec_cmd("hyprshell init --show-title")
          -- Clipboard daemon
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("wl-paste --type image --watch cliphist store")
        end)
      '';
    };

    home.packages =
      (with pkgs; [
        hyprlauncher
        hyprlock
        hyprpolkitagent
        grim
        slurp
        wl-clipboard
        cliphist
      ])
      ++ [ inputs.hyprswitch.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
