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
          padding = {
            x = 4;
            y = 8;
          };
          option_as_alt = "Both";
          blur = true;
          decorations = "full";
          opacity = 1;
          startup_mode = "Windowed";
          title = "Alacritty";
          dynamic_title = true;
          decorations_theme_variant = "None";
          dimensions = {
            columns = 160;
            lines = 80;
          };
        };

        font = let
          iosevka = style: {
            family = "Iosevka Nerd Font";
            inherit style;
          };
        in {
          size = 20;
          normal = iosevka "Regular";
          bold = iosevka "Bold";
          italic = iosevka "Italic";
          bold_italic = iosevka "Bold Italic";
        };

        general.live_config_reload = true;

        colors = {
          draw_bold_text_with_bright_colors = true;
          transparent_background_colors = true;
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

        env = { TERM = "xterm-256color"; };
      };
    };
  };
}
