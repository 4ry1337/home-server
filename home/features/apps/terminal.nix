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
        general.import = [
          "${pkgs.alacritty-theme}/share/alacritty-theme/${cfg.alacritty.theme}.toml"
        ];

        window.opacity = 0.9;

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
        };

        colors.draw_bold_text_with_bright_colors = true;

        cursor = {
          blink_interval = 500;
          unfocused_hollow = false;
          style = {
            blinking = "On";
            shape = "Underline";
          };
        };

        mouse.hide_when_typing = true;
      };
    };
  };
}
