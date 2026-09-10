{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.zoxide;
in
{
  options.features.cli.zoxide.enable = mkEnableOption "Enable zoxide";
  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      # replace `cd` with the zoxide function (also gives `cdi` interactive);
      # `z`/`zi` are not defined in this mode
      options = [ "--cmd cd" ];
    };
  };
}
