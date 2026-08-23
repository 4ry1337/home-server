{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.rdp;
in
{
  options.features.apps.rdp.enable = mkEnableOption "Enable RDP";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      remmina
    ];
  };
}
