{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.hyprland;
  mkLua = lib.generators.mkLuaInline;
in
{
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

        window_rule = {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        };

        bind = [
          # Apps (Windows-style)
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
              "SUPER + L"
              (mkLua "hl.dsp.exec_cmd(\"hyprlock\")")
            ];
          }
          {
            _args = [
              "SUPER + M"
              (mkLua "hl.dsp.exit()")
            ];
          }

          # Window management
          {
            _args = [
              "SUPER + Q"
              (mkLua "hl.dsp.window.close()")
            ];
          }
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

          # Mouse move/resize
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

        -- Screenshot region to clipboard (like Snipping Tool)
        hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bash -c 'grim -g \"$(slurp)\" - | wl-copy'"))

        -- Clipboard history via cliphist + hyprlauncher dmenu
        hl.bind("SUPER + V", hl.dsp.exec_cmd("bash -c 'cliphist list | hyprlauncher -m | cliphist decode | wl-copy'"))

        -- Clipboard daemon (populates cliphist on clipboard change)
        hl.on("hyprland.start", function()
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("wl-paste --type image --watch cliphist store")
        end)
      '';
    };

    home.packages = with pkgs; [
      hyprlauncher
      hyprlock
      grim
      slurp
      wl-clipboard
      cliphist
    ];
  };
}
