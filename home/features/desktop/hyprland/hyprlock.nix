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
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 7;
            brightness = 0.6;
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "300, 50";
            position = "0, -80";
            halign = "center";
            valign = "center";
            dots_center = true;
            fade_on_empty = false;
            placeholder_text = "";
            outer_color = "rgb(b4befe)";
            inner_color = "rgb(181825)";
            font_color = "rgb(cdd6f4)";
            check_color = "rgb(a6e3a1)";
            fail_color = "rgb(f38ba8)";
            shadow_passes = 1;
          }
        ];

        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
            font_size = 64;
            font_family = "Iosevka Nerd Font Mono";
            color = "rgba(cdd6f4ff)";
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
