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
  mainMod = "SUPER";

  wfRecorderToggleScript = pkgs.writeShellScriptBin "wf-recorder-toggle" ''
    #!/usr/bin/env bash
    if pgrep -x wf-recorder > /dev/null; then
      pkill -INT wf-recorder
    else
      mkdir -p "$HOME/Videos/recordings"
      region=$(slurp)
      [ -n "$region" ] && wf-recorder -g "$region" -f "$HOME/Videos/recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"
    fi
  '';
in
{
  imports = [
    # ./waybar.nix
    ./wayle.nix
    ./swaync.nix
    ./hyprpaper.nix
    ./hyprlock.nix
  ];

  options.features.desktop.hyprland.enable = mkEnableOption "hyprland wayland compositor";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = with pkgs.hyprlandPlugins; [ hyprbars hyprspace ];
      settings = {
        mainMod = {
          _var = mainMod;
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
            kb_layout = "us,ru";
            kb_options = "grp:win_space_toggle,caps:escape";
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
            float = true;
          }
          {
            name = "float-nm-connection-editor";
            match.class = "nm-connection-editor";
            float = true;
          }
          {
            name = "float-blueman";
            match.class = "blueman-manager";
            float = true;
          }
          # Float file picker dialogs
          {
            name = "float-file-picker";
            match.title = "^(Open|Save|Save As).*";
            float = true;
          }
          # Float + pin picture-in-picture
          {
            name = "float-pip";
            match.title = "^Picture-in-Picture$";
            float = true;
            pin = true;
          }
        ];

        plugin = {
          hyprbars = {
            bar_height = 20;
            bar_text_size = 11;
            bar_padding = 8;
            bar_button_padding = 5;
          };
          overview = {
            exitOnClick = true;
            exitOnSwitch = true;
          };
        };

        bind = [
          # Hyprspace overview
          {
            _args = [
              "${mainMod} + TAB"
              (mkLua "hl.dsp.exec_cmd(\"hyprctl dispatch overview:toggle\")")
            ];
          }

          # Apps
          {
            _args = [
              "${mainMod} + T"
              (mkLua "hl.dsp.exec_cmd(\"alacritty\")")
            ];
          }
          {
            _args = [
              "${mainMod} + E"
              (mkLua "hl.dsp.exec_cmd(\"nautilus\")")
            ];
          }
          {
            _args = [
              "${mainMod} + S"
              (mkLua "hl.dsp.exec_cmd(\"hyprlauncher\")")
            ];
          }
          {
            _args = [
              "${mainMod} + ESCAPE"
              (mkLua "hl.dsp.exec_cmd(\"hyprlock\")")
            ];
          }
          {
            _args = [
              "${mainMod} + M"
              (mkLua "hl.dsp.exit()")
            ];
          }

          # hyprswitch (ALT+Tab) — disabled until egnrse/hyprswitch fixes Lua config compat
          # {
          #   _args = [
          #     "ALT + Tab"
          #     (mkLua "hl.dsp.exec_cmd(\"hyprswitch gui --mod-key alt --key tab\")")
          #   ];
          # }

          # Workspace: scroll with SUPER+wheel
          {
            _args = [
              "${mainMod} + mouse_down"
              (mkLua "hl.dsp.focus({ workspace = \"r+1\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + mouse_up"
              (mkLua "hl.dsp.focus({ workspace = \"r-1\" })")
            ];
          }

          # Window: close
          {
            _args = [
              "${mainMod} + Q"
              (mkLua "hl.dsp.window.close()")
            ];
          }
          # Window: fullscreen / maximize
          {
            _args = [
              "${mainMod} + F"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"fullscreen\", action = \"toggle\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + Up"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })")
            ];
          }

          # Window: focus (vim-style)
          {
            _args = [
              "${mainMod} + H"
              (mkLua "hl.dsp.focus({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + J"
              (mkLua "hl.dsp.focus({ direction = \"down\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + K"
              (mkLua "hl.dsp.focus({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + L"
              (mkLua "hl.dsp.focus({ direction = \"right\" })")
            ];
          }

          # Window: move (vim-style + arrow keys)
          {
            _args = [
              "${mainMod} + SHIFT + H"
              (mkLua "hl.dsp.window.move({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + J"
              (mkLua "hl.dsp.window.move({ direction = \"down\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + K"
              (mkLua "hl.dsp.window.move({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + L"
              (mkLua "hl.dsp.window.move({ direction = \"right\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + left"
              (mkLua "hl.dsp.window.move({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + right"
              (mkLua "hl.dsp.window.move({ direction = \"right\" })")
            ];
          }
          # Window: move to next/prev workspace
          {
            _args = [
              "${mainMod} + SHIFT + left"
              (mkLua "hl.dsp.window.move({ workspace = \"r-1\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + right"
              (mkLua "hl.dsp.window.move({ workspace = \"r+1\" })")
            ];
          }

          # Mouse: drag / resize
          {
            _args = [
              "${mainMod} + mouse:272"
              (mkLua "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              "${mainMod} + mouse:273"
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
          {
            _args = [
              "XF86AudioPlay"
              (mkLua "hl.dsp.exec_cmd(\"playerctl play-pause\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              "XF86AudioNext"
              (mkLua "hl.dsp.exec_cmd(\"playerctl next\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              "XF86AudioPrev"
              (mkLua "hl.dsp.exec_cmd(\"playerctl previous\")")
              { locked = true; }
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
        hl.bind("${mainMod} + SHIFT + S", hl.dsp.exec_cmd("bash -c 'grim -g \"$(slurp)\" - | swappy -f -'"))

        -- Screen recording toggle (region select via slurp, saves to ~/Videos/recordings)
        hl.bind("${mainMod} + SHIFT + R", hl.dsp.exec_cmd("${wfRecorderToggleScript}/bin/wf-recorder-toggle"))

        -- Clipboard history
        hl.bind("${mainMod} + V", hl.dsp.exec_cmd("bash -c 'cliphist list | hyprlauncher -m | cliphist decode | wl-copy'"))

        -- Toggle dwindle split orientation
        hl.bind("${mainMod} + backslash", hl.dsp.layout("togglesplit"))

        -- Resize submap: SUPER+R to enter, H/J/K/L to resize, ESC to exit
        hl.bind("${mainMod} + R", hl.dsp.submap("resize"))
        hl.define_submap("resize", "reset", function()
          hl.bind("H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
          hl.bind("L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
          hl.bind("K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
          hl.bind("J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
          hl.bind("escape", hl.dsp.submap("reset"))
        end)

        hl.on("hyprland.start", function()
          -- Polkit authentication agent
          hl.exec_cmd("hyprpolkitagent")
          -- hyprswitch disabled until egnrse/hyprswitch fixes Lua config compat
          -- hl.exec_cmd("hyprswitch init --show-title")
          -- Clipboard daemon
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("wl-paste --type image --watch cliphist store")
          -- Blue light filter daemon (wayle hyprsunset toggle requires this)
          hl.exec_cmd("hyprsunset -t 5000")
          -- Idle daemon
          hl.exec_cmd("hypridle")
          -- Wallpaper daemon (required by wayle wallpaper cycling)
          hl.exec_cmd("awww-daemon")
        end)
      '';
    };

    home.packages =
      (with pkgs; [
        hyprlauncher
        hyprlock
        hyprpolkitagent
        hyprsunset
        hypridle
        awww
        grim
        slurp
        swappy
        wl-clipboard
        cliphist
        wf-recorder
        playerctl
      ])
      ++ [ inputs.hyprswitch.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
