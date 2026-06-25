{ ... }: {
  imports = [
    ./home.nix
    ./dotfiles
    ../common
    ../features/apps
    ../features/cli
    ../features/desktop
    # ../features/gaming
    ../features/languages
  ];
  features = {
    cli = {
      ai.enable = true;
      kmscon.enable = true;
      tty-browser.enable = true;
      eza.enable = true;
      fzf.enable = true;
      git.enable = true;
      neovim.enable = true;
      oh-my-posh.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
    desktop = {
      fonts.enable = true;
      hyprland.enable = true;
    };
  };
}
