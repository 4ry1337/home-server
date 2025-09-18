{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./neovim.nix
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraOptions = ["-l" "--icons" "--git" "-a"];
  };

  programs.bat = {enable = true;};

  home.packages = with pkgs; [
    fzf
    fd
    jq
    ripgrep
    zip
    unzip
  ];
}

