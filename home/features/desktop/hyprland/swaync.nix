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
    services.swaync = {
      enable = true;
    };
  };
}
