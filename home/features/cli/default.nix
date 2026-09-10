{ pkgs, ... }: {
  imports = [
    ./disk.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./network.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    btop
    wl-clipboard
    fastfetch
    coreutils
    fd
    jq
    ripgrep
  ];
}
