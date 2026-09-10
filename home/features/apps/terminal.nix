{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.terminal;
in
{
  options.features.apps.terminal = {
    alacritty.enable = mkEnableOption "Enable alacritty application";
    alacritty.theme = mkOption {
      type = types.str;
      default = "tokyo_night";
      example = "monokai";
      description = "alacritty-theme file name (without .toml extension).";
    };
  };

  config = mkIf cfg.alacritty.enable {
    home.sessionVariables.TERMINAL = "alacritty";

    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          live_config_reload = true;
          import = [
            "${pkgs.alacritty-theme}/share/alacritty-theme/${cfg.alacritty.theme}.toml"
          ];
        };

        env.TERM = "xterm-256color";

        terminal.shell = {
          program = "/usr/bin/env";
          args = [ "zsh" ];
        };

        window = {
          decorations = "Full";
          dynamic_title = true;
          option_as_alt = "Both";
          opacity = 1;
          blur = true;
          dimensions = {
            columns = 160;
            lines = 80;
          };
        };

        font = {
          size = 20;
          normal = {
            family = "IosevkaTerm Nerd Font Mono";
            style = "Semibold";
          };
          bold = {
            family = "IosevkaTerm Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "IosevkaTerm Nerd Font Mono";
            style = "Italic";
          };
          offset = {
            x = 0;
            y = 0;
          };
        };

        colors = {
          draw_bold_text_with_bright_colors = true;
          transparent_background_colors = true;
        };

        bell = {
          animation = "EaseOutExpo";
          duration = 0;
        };

        selection.semantic_escape_chars = ",│`|:\"' ()[]{}<>";

        cursor = {
          blink_interval = 500;
          blink_timeout = 5;
          unfocused_hollow = false;
          style = {
            blinking = "On";
            shape = "Underline";
          };
        };

        mouse = {
          hide_when_typing = true;
          bindings = [
            {
              mouse = "Middle";
              action = "PasteSelection";
            }
          ];
        };

        keyboard.bindings = [
          {
            key = "+";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "-";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "=";
            mods = "Control";
            action = "ResetFontSize";
          }
        ];
      };
    };
  };
}
