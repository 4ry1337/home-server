{ pkgs, ... }: {
  imports = [ ./media.nix ./obs.nix ];
  home.packages = with pkgs; [
    alacritty
    google-chrome
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
    libreoffice
    calcurse
    vdirsyncer
  ];
}
