{ pkgs, ... }:
{
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

  environment.systemPackages = with pkgs; [
    openconnect
  ];
}
