{ inputs, ... }: {
  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/.config/nvim";
    recursive = true;
  };
  home.file.".config/oh-my-posh" = {
    source = "${inputs.dotfiles}/.config/oh-my-posh";
    recursive = true;
  };
}
