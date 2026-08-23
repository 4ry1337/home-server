{ pkgs, ... }: {
  imports = [
    ./rdp.nix
    ./media.nix
    ./obs.nix
    ./calendar.nix
  ];
  home.packages = with pkgs; [
    alacritty
    google-chrome
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
    libreoffice
  ];
}
