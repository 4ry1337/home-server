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
  options.features.desktop.hyprland.wallpaper = mkOption {
    type = types.str;
    default = "";
    description = "Absolute path to wallpaper image. Leave empty to disable hyprpaper.";
  };

  config = mkIf (cfg.enable && cfg.wallpaper != "") {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ cfg.wallpaper ];
        # empty monitor string = apply to all monitors
        wallpaper = [ ", ${cfg.wallpaper}" ];
      };
    };
  };
}
