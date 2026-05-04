{ pkgs, ... }: {
  imports = [ ./alacritty.nix ./chrome.nix ./claude-code.nix ];
  home.packages = with pkgs; [ firefox ];
}

