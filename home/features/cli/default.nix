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
    ./tmux.nix
    ./w3m.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    btop
    wl-clipboard
    fastfetch
    coreutils
    tree
    fd
    jq
    ripgrep
  ];
}
