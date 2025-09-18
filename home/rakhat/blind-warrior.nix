{ config, ... }: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
    ../features/apps
    ../features/desktop
  ];

  features = {
    cli = {
      zsh.enable = true;
      tmux.enable = true;
      neovim.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
    };
    apps = { alacritty.enable = true; };
    desktop = {
      hyprland.enable = true;
      wayland.enable = true;
    };
  };
}

