{ config, lib, ... }:
with lib;
let cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable =
    mkEnableOption "hyprland wayland compositor";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
  };
}
