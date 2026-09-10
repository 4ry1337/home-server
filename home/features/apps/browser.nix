{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.browser;
in
{
  options.features.apps.browser = {
    google-chrome.enable = mkEnableOption "Enable google-chrome application";
  };

  config = mkIf cfg.google-chrome.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
