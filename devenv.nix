{
  pkgs,
  # lib,
  # config,
  # inputs,
  ...
}:

{
  languages.nix = {
    enable = true;
    lsp.enable = true;
  };

  git-hooks.hooks = {
    typos.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };

  packages = with pkgs; [
    nixfmt
    typos-lsp
  ];
  # See full reference at https://devenv.sh/reference/options/
}
