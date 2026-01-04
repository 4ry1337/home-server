{ pkgs, ... }: {
  imports = [ ./wayland.nix ./hyperland.nix ./fonts.nix ];

  home.packages = with pkgs; [ ];
}
