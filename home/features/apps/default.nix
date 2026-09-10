{ pkgs, ... }: {
  imports = [
    ./rdp.nix
    ./media.nix
    ./obs.nix
    ./blender.nix
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
