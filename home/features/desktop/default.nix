{ pkgs, ... }: {
  imports = [ ./wayland.nix ./hyperland.nix ];

  home.packages = with pkgs; [ ];
}
