{ ... }: {
  imports = [
    ./home.nix
    ./dotfiles
    ../common
    ../features/apps
    ../features/cli
    ../features/desktop
    ../features/dev
    ../features/gaming
  ];
  features = {
    dev.enable = true;
    apps = {
      media.enable = true;
      obs.enable = true;
      terminal.alacritty = {
        enable = true;
        theme = "tokyo_night";
      };
      browser.google-chrome.enable = true;
    };
    cli = {
      disk.enable = true;
      network.enable = true;
      eza.enable = true;
      fzf.enable = true;
      git.enable = true;
      neovim.enable = true;
      oh-my-posh.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
    desktop = {
      hyprland.enable = true;
    };
  };
}
