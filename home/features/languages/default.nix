{ pkgs, ... }: {
  home.packages = with pkgs; [
    devenv
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
