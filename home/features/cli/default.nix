{ pkgs, ... }: {
  imports = [ ./zsh.nix ./fzf.nix ./fastfetch.nix ./tmux.nix ./neovim.nix ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraOptions = [ "-l" "--icons" "--git" "-a" ];
  };

  programs.bat = { enable = true; };

  home.packages = with pkgs; [ nodejs fzf fd jq ripgrep zip unzip ];
}
