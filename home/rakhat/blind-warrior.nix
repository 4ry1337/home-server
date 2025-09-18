{
  imports = [
    ./home.nix
    ./dotfiles
    ../common
    ../features/cli
    ../features/apps
    ../features/desktop
    ../features/languages
  ];

  features = {
    cli = {
      zsh.enable = true;
      tmux.enable = true;
      neovim.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
      oh-my-posh.enable = true;
    };
    apps.alacritty.enable = true;
    desktop = {
      hyprland.enable = true;
      wayland.enable = true;
      fonts.enable = true;
    };
  };
}
