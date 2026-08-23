{ pkgs, ... }:
{
  obs-spotify-widget = pkgs.callPackage ./obs-spotify-widget.nix { };
  hyprexpo = pkgs.callPackage ./hyprexpo.nix { };
}
