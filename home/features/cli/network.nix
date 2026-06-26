{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.cli.network;
in
{
  options.features.cli.network.enable = mkEnableOption "network tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # diagnostics
      mtr
      tcpdump
      nmap

      # dns
      dnsutils
      dog

      # bandwidth
      iperf3
      bandwhich

      # tunneling / vpn
      wireguard-tools
      mosh

      # security audit
      nftables
    ];
  };
}
