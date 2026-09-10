{ pkgs, ... }: {
  imports = [
    ./rdp.nix
    ./media.nix
    ./obs.nix
    ./calendar.nix
    ./blender.nix
    ./office.nix
    ./terminal.nix
    ./browser.nix
  ];
  home.packages = with pkgs; [
    nautilus
    obsidian
    stable.spotify
    stable.telegram-desktop
  ];
}
