{ pkgs, ... }: {
  imports = [
    ./rdp.nix
    ./media.nix
    ./obs.nix
    ./calendar.nix
    ./blender.nix
    ./office.nix
    ./terminal.nix
  ];
  home.packages = with pkgs; [
    google-chrome
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
  ];
}
