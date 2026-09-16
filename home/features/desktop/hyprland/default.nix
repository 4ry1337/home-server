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
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        mainMod = {
          _var = mainMod;
        };

        monitor = [
          {
            output = "desc: Samsung Electric Company LS27CG51x H9JW800118";
            scale = 1.25;
          }
          {
            output = "eDP-1";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
          {
            output = "HDMI-A-1";
            mode = "preferred";
            position = "auto-center-up";
            scale = 1.25;
          }
        ];

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
            touchpad = {
              natural_scroll = true;
            };
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
            match.title = "^Picture in picture$";
            float = true;
            pin = true;
          }
        ];

        gesture = [
          # Workspace: switch with 3-finger horizontal swipe
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
          # Window switcher: 3-finger swipe up (mimics Mission Control / Task View)
          {
            fingers = 3;
            direction = "up";
            action = mkLua "function() hl.dsp.exec_cmd(\"snappy-switcher next --mod alt\") end";
          }
          # {
          #   fingers = 3;
          #   direction = "down";
          #   action = "";
          # }
        ];

        bind = [
          {
            _args = [
              "${mainMod} + Tab + ESCAPE"
              (mkLua "hl.dsp.exit()")
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
          # snappy-switcher (ALT+Tab)
          {
            _args = [
              "ALT + Tab"
              (mkLua "hl.dsp.exec_cmd(\"snappy-switcher next --mod alt\")")
            ];
          }
          # Screenshot region to clipboard
          {
            _args = [
              "${mainMod} + SHIFT + S"
              (mkLua "hl.dsp.exec_cmd(\"bash -c 'grim -g \\\"$(slurp)\\\" - | swappy -f -'\")")
            ];
          }
          # Screen recording toggle (region select via slurp, saves to ~/Videos/recordings)
          {
            _args = [
              "${mainMod} + SHIFT + R"
              (mkLua "hl.dsp.exec_cmd(\"${wfRecorderToggleScript}/bin/wf-recorder-toggle\")")
            ];
          }
          # Clipboard history
          {
            _args = [
              "${mainMod} + V"
              (mkLua "hl.dsp.exec_cmd(\"bash -c 'cliphist list | hyprlauncher -m | cliphist decode | wl-copy --type text/plain'\")")
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
          # Window: close
          {
            _args = [
              "${mainMod} + Q"
              (mkLua "hl.dsp.window.close()")
            ];
          }
          # Toggle dwindle split orientation
          {
            _args = [
              "${mainMod} + backslash"
              (mkLua "hl.dsp.layout(\"togglesplit\")")
            ];
          }
          # Window: fullscreen
          {
            _args = [
              "${mainMod} + F"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"fullscreen\", action = \"toggle\" })")
            ];
          }
          # Window: maximize
          {
            _args = [
              "${mainMod} + M"
              (mkLua "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })")
            ];
          }
          # Window: toggle floating
          {
            _args = [
              "${mainMod} + SHIFT + F"
              (mkLua "hl.dsp.window.float()")
            ];
          }
          # Window: toggle pin (stays on top, visible on all workspaces)
          {
            _args = [
              "${mainMod} + SHIFT + P"
              (mkLua "hl.dsp.window.pin()")
            ];
          }
          # Window: drag
          {
            _args = [
              "${mainMod} + mouse:272"
              (mkLua "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          # Window: resize
          {
            _args = [
              "${mainMod} + mouse:273"
              (mkLua "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }
          # Window: resize submap SUPER+R to enter (submap body defined in extraConfig)
          {
            _args = [
              "${mainMod} + R"
              (mkLua "hl.dsp.submap(\"resize\")")
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
          # Window: move (vim-style)
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
          # Window: move to next/prev workspace
          {
            _args = [
              "${mainMod} + CTRL + SHIFT + H"
              (mkLua "hl.dsp.window.move({ workspace = \"r-1\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + CTRL + SHIFT + L"
              (mkLua "hl.dsp.window.move({ workspace = \"r+1\" })")
            ];
          }
          # Workspace: focus (vim-style)
          {
            _args = [
              "${mainMod} + CTRL + H"
              (mkLua "hl.dsp.focus({ workspace = \"r-1\" })")
            ];
          }
          {
            _args = [
              "${mainMod} + CTRL + L"
              (mkLua "hl.dsp.focus({ workspace = \"r+1\" })")
            ];
          }
        ]
        # Workspace: switching 1-10 (focus)
        ++ (map (i: {
          _args = [
            "${mainMod} + ${toString (mod i 10)}"
            (mkLua "hl.dsp.focus({ workspace = ${toString i} })")
          ];
        }) (range 1 10))
        # Workspace: switching 1-10 (move window)
        ++ (map (i: {
          _args = [
            "${mainMod} + SHIFT + ${toString (mod i 10)}"
            (mkLua "hl.dsp.window.move({ workspace = ${toString i} })")
          ];
        }) (range 1 10));
      };

      extraConfig = ''
        -- Resize submap: H/J/K/L to resize, ESC to exit
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
          -- Window switcher daemon
          hl.exec_cmd("snappy-switcher --daemon")
          -- Clipboard daemon
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("wl-paste --type image --watch cliphist store")
          -- Blue light filter daemon (wayle hyprsunset toggle requires this)
          hl.exec_cmd("hyprsunset -t 5000")
          -- Idle daemon
          hl.exec_cmd("hypridle")
          -- Wallpaper daemon (required by wayle wallpaper cycling)
          hl.exec_cmd("awww-daemon")
          -- Network manager tray icon
          hl.exec_cmd("nm-applet --indicator")
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
      ++ [ inputs.snappy-switcher.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
