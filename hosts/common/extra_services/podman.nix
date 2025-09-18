{ config, lib, pkgs, ... }:
with lib;
let cfg = config.extra_services.podman;
in {
  options.extra_services.podman.enable = mkEnableOption "Enable Podman";

  config = mkIf cfg.enable {
    virtualization = {
      podman = {
        enable = true;
        dockerCompat = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--filter=until=24h" "--filter=label!=important" ];
        };
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    environemnt.systemPackage = with pkgs; [ podman-compose ];
  };
}
