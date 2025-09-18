{ config, ... }: {
  imports = [ ./home.nix ../common ../features/cli ../features/desktop ];

  features = {
    cli = {
      zsh.enable = true;
      tmux.enable = true;
      neovim.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
    };
  };
}

