{ inputs, ... }: {
  home.file = {
    ".config/nvim" = {
      source = "${inputs.dotfiles}/.config/nvim";
      recursive = true;
    };
    ".config/alacritty" = {
      source = "${inputs.dotfiles}/.config/alacritty";
      recursive = true;
    };
    ".config/tmux" = {
      source = "${inputs.dotfiles}/.config/tmux";
      recursive = true;
    };
    ".config/oh-my-posh" = {
      source = "${inputs.dotfiles}/.config/oh-my-posh";
      recursive = true;
    };
    ".config/tmux/plugins/tpm" = {
      source = inputs.tpm;
    };
  };
}
