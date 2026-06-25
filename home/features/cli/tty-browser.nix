{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.tty-browser;
in {
  options.features.cli.tty-browser.enable = mkEnableOption "Enable tty browser";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ddgr
      w3m
    ];
  };
}
