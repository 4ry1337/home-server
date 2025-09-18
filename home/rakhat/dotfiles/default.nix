{ inputs, ... }: {
  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/.config/nvim";
    recursive = true;
  };
  home.file.".config/alacritty" = {
    source = "${inputs.dotfiles}/.config/alacritty";
    recursive = true;
  };
}
