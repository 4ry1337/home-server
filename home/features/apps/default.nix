{ pkgs, ... }: {
  imports = [
    ./rdp.nix
    ./media.nix
    ./obs.nix
    ./calendar.nix
    ./blender.nix
    ./office.nix
  ];
  home.packages = with pkgs; [
    alacritty
    google-chrome
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
  ];
}
