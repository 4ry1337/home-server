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
    apps = {
      media.enable = true;
      obs.enable = true;
      calendar.enable = true;
    };
    cli = {
      ai.enable = false;
      disk.enable = true;
      kmscon.enable = true;
      network.enable = true;
      w3m.enable = true;
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
