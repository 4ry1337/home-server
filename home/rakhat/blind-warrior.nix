{ inputs, ... }: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./home.nix
    ./dotfiles
    ../common
    ../features/cli
    ../features/apps
    ../features/desktop
    ../features/gaming
    ../features/languages
  ];

  # Global Catppuccin theme — applies to all supported programs
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  features = {
    cli = {
      zsh.enable = true;
      tmux.enable = true;
      neovim.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
      oh-my-posh.enable = true;
    };
    apps = {
      chrome.enable = true;
      alacritty.enable = true;
      claude-code.enable = true;
      telegram.enable = true;
      spotify.enable = true;
      obsidian.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      wayland.enable = true;
      fonts.enable = true;
    };
  };
}
