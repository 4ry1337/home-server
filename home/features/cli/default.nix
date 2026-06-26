{ pkgs, ... }: {
  imports = [
    ./ai.nix
    ./disk.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./kmscon.nix
    ./neovim.nix
    ./network.nix
    ./oh-my-posh.nix
    ./w3m.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    tmux
    wl-clipboard
    fastfetch
    coreutils
    tree
    fd
    btop
    jq
    ripgrep
    gcc
  ];
}
