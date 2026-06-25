{ pkgs, ... }: {
  imports = [ ];
  home.packages = with pkgs; [
    alacritty
    google-chrome
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
  ];
}
