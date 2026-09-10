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
    alacritty.enable = mkEnableOption "Alacritty terminal";
    kitty.enable = mkEnableOption "Kitty terminal";
    ghostty.enable = mkEnableOption "Ghostty terminal";
  };

  config.home.packages =
    optional cfg.alacritty.enable pkgs.alacritty
    ++ optional cfg.kitty.enable pkgs.kitty
    ++ optional cfg.ghostty.enable pkgs.ghostty;
}
