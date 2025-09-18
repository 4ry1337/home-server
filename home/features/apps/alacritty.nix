{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.apps.alacritty;
in {
  options.features.apps.alacritty.enable = mkEnableOption "Enable Alacritty";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ alacritty ];
    programs.alacritty = {
      enable = true;
      settings = {
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

        import = [ pkgs.alacritty-theme.tokyo-night ];

        font = let
          iosevkaTerm = style: {
            family = "IosevkaTerm";
            inherit style;
          };
        in {
          size = 20;
          normal = iosevkaTerm "Regular";
          bold = iosevkaTerm "Bold";
          italic = iosevkaTerm "Italic";
          bold_italic = iosevkaTerm "Bold Italic";
          offset = {
            x = 0;
            y = 0;
          };
        };

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
          bindings = [{
            mouse = "Middle";
            action = "PasteSelection";
          }];
        };

        keyboard = {
          bindings = [
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

        env = { TERM = "xterm-256color"; };

        live_config_reload = true;
      };
    };
  };
}
