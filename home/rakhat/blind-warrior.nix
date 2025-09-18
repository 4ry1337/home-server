{ config, ... }: 
{ 
  imports = [
    ./home.nix
    ../common
    ../features/cli
  ];

  features = {
    cli = {
      zsh.enable = true;
      tmux.enable = true;
      neovim.enable = true;
    };
  };
}

